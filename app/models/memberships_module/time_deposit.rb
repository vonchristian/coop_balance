module MembershipsModule
  class TimeDeposit < ApplicationRecord
    enum status: [:withdrawn]
    include PgSearch
    pg_search_scope :text_search, against: [:depositor_name, :account_number]
    belongs_to :depositor, polymorphic: true
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"
    belongs_to :time_deposit_product, class_name: "CoopServicesModule::TimeDepositProduct"
    has_many :entries,  class_name: "AccountingModule::Entry", as: :commercial_document, dependent: :destroy
    has_many :fixed_terms, class_name: "TimeDepositsModule::FixedTerm", dependent: :destroy
    delegate :name, :interest_rate, :account, to: :time_deposit_product, prefix: true
    delegate :name, :full_name, :first_and_last_name, to: :depositor, prefix: true
    delegate :maturity_date, :deposit_date, :matured?, to: :current_term, prefix: true
    delegate :name, to: :office, prefix: true
    before_save :set_depositor_name, on: [:create]

    validates :depositor_id, :depositor_type,  presence: true

    after_commit :set_account_number
    def can_be_extended?
      !withdrawn? && matured?
    end
    def withdrawal_date
      if withdrawn?
        entries.order(created_at: :asc).last.entry_date
      end
    end
    def current_term
      fixed_terms.order(created_at: :asc).last
    end

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
      TimeDepositsModule::InterestEarnedPosting.post_for(self)
    end

    def matured?
      current_term.matured?
    end

    def amount_deposited
      time_deposit_product_account.balance(commercial_document_id: self.id)
      # entries.map{|a| a.debit_amounts.sum(:amount) }.sum
    end

    def balance
      time_deposit_product_account.balance(commercial_document_id: self.id)
    end

    def earned_interests
      CoopConfigurationsModule::TimeDepositConfig.earned_interests_for(self)
    end


    private
    def set_account_number
      self.account_number = self.id
    end

    def set_depositor_name
      self.depositor_name ||= self.depositor_full_name
    end
  end
end
