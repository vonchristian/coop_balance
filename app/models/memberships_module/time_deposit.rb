module MembershipsModule
  class TimeDeposit < ApplicationRecord
    enum status: [:closed]
    include PgSearch
    pg_search_scope :text_search, against: [:depositor_name, :account_number]
    belongs_to :depositor, polymorphic: true
    belongs_to :time_deposit_product, class_name: "CoopServicesModule::TimeDepositProduct"
    has_many :deposits,  class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy

    delegate :name, :interest_rate, :account, to: :time_deposit_product, prefix: true
    delegate :full_name, :first_and_last_name, to: :depositor, prefix: true

    before_save :set_date_deposited, :set_depositor_name, on: [:create]

    validates :depositor_id, :depositor_type,  presence: true
    validates :number_of_days, presence: true, numericality: true
    after_commit :set_maturity_date, :set_account_number
    def member?
      depositor.regular_member?
    end

    def non_member?
      !depositor.regular_member?
    end

    def self.matured
      all.select{|a| a.matured? }
    end
    def self.post_interests_earned
      !matured.each do |time_deposit|
        post_interests_earned
      end
    end
    def post_interests_earned
      if !matured?
        AccountingModule::Entry.time_deposit_interest.create!(commercial_document: self, description: 'Time deposit earned interest', entry_date: Time.zone.now,
          debit_amounts_attributes: [account_id: AccountingModule::Account.find_by(name: "Interest Expense on Deposits").id, amount: self.balance * (self.time_deposit_product_interest_rate / 100.0) ],
          credit_amounts_attributes: [account_id: AccountingModule::Account.find_by(name: "Time Deposits").id, amount: self.balance * (self.time_deposit_product_interest_rate / 100.0) ])
      end
    end

    def matured?
      maturity_date < Time.zone.now
    end
    def transfer_to_savings
      #if matured?
      #find_member_savings_accounts
      #if savings_accounts.present?
        #select last saving account
        #add time deposit balance to saving account balance
      #elsif no account found
      #create savings account
      # add time dpeosit balance to saving account balance
      #
    end

    def amount_deposited
      deposits.time_deposit.map{|a| a.debit_amounts.sum(:amount) }.sum
    end

    def balance
      time_deposit_product_account.balance(commercial_document_id: self.id)
    end

    def earned_interests
      deposits.time_deposit_interest.map{|a| a.debit_amounts.sum(:amount) }.sum
    end

    def withdrawn?
      deposits.withdrawal.present?
    end
    private
    def set_account_number
      self.account_number = self.id
    end
    def set_date_deposited
      self.date_deposited ||= Time.zone.now
    end
    def set_depositor_name
      self.depositor_name ||= self.depositor_full_name
    end
    def set_maturity_date
      self.maturity_date = date_deposited + number_of_days.days
    end
  end
end
