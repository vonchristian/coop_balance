module DepositsModule
  class TimeDeposit < ApplicationRecord
    enum status: [:withdrawn]
    include PgSearch::Model
    pg_search_scope :text_search, against: [:account_number, :depositor_name]

    belongs_to :cooperative
    belongs_to :depositor,                polymorphic: true
    belongs_to :office,                   class_name: "Cooperatives::Office"
    belongs_to :time_deposit_product,     class_name: "CoopServicesModule::TimeDepositProduct"
    belongs_to :organization,             optional: true
    belongs_to :barangay,                 optional: true, class_name: "Addresses::Barangay"
    belongs_to :liability_account,        class_name: 'AccountingModule::Account'
    belongs_to :interest_expense_account, class_name: 'AccountingModule::Account'
    belongs_to :break_contract_account,   class_name: 'AccountingModule::Account'
    has_one  :term,                       as: :termable
    has_many :ownerships,                 as: :ownable
    has_many :depositors,                 through: :ownerships, source: :owner
    has_many :accountable_accounts,       class_name: 'AccountingModule::AccountableAccount', as: :accountable
    has_many :accounts,                   through: :accountable_accounts, class_name: 'AccountingModule::Account'
    has_many :entries,                    through: :accounts , class_name: 'AccountingModule::Entry'

    delegate :name, :interest_rate, :account, :break_contract_fee, to: :time_deposit_product, prefix: true
    delegate :full_name, :first_and_last_name, to: :depositor, prefix: true
    delegate :name, to: :office, prefix: true
    delegate :name, to: :depositor
    delegate :avatar, to: :depositor
    delegate :maturity_date, :effectivity_date, :matured?, to: :term, prefix: true
    delegate :remaining_term,  to: :term
    delegate :balance, :debits_balance, :credits_balance, to: :liability_account

    before_save :set_depositor_name

    def self.liability_accounts
      ids = pluck(:liability_account_id)
      AccountingModule::Liability.where(id: ids)
    end

    def self.interest_expense_accounts
      ids = pluck(:interest_expense_account_id)
      AccountingModule::Liability.where(id: ids)
    end

    def self.break_contract_accounts
      ids = pluck(:interest_expense_account_id)
      AccountingModule::Revenue.where(id: ids)
    end

    def self.total_balances(args= {})
      liability_accounts.balance(args)
    end

    def self.deposited_on(args={})
      from_date  = args[:from_date] || 999.years.ago
      to_date    = args[:to_date]
      date_range = DateRange.new(from_date: from_date, to_date: to_date)

      joins(:term).where('terms.effectivity_date' => date_range.start_date..date_range.end_date)
    end



    def can_be_extended?
      !withdrawn? && term_matured?
    end

    def withdrawal_date
      if withdrawn?
        liability_account.entries.order(entry_date: :asc).last.entry_date
      end
    end


    def self.not_withdrawn
      where(withdrawn: false)
    end

    def member?
      depositor.regular_member?
    end

    def non_member?
      !depositor.regular_member?
    end

    def self.matured
      all.select{ |a| a.term_matured? }
    end

    def self.post_interests_earned
      !term_matured.each do |time_deposit|
        post_interests_earned
      end
    end

    def post_interests_earned
      TimeDepositsModule::InterestEarnedPosting.post_for(self)
    end

    def amount_deposited
      credits_balance - interest_balance
    end

    def disbursed?
      true
    end



    def interest_balance(args={})
      interest_expense_account.debits_balance(args)
    end

    def deposited_amount
      amount_deposited
    end

    def earned_interests
      CoopConfigurationsModule::TimeDepositConfig.earned_interests_for(self)
    end

    def computed_break_contract_amount
      time_deposit_product.break_contract_rate * amount_deposited
    end

    def computed_earned_interests
      if term.matured?
        amount_deposited * rate
      else
        amount_deposited *
        applicable_rate *
        days_elapsed
      end
    end

    def days_elapsed
       (Time.zone.now - date_deposited) /86400
    end


    def rate
      time_deposit_product.monthly_interest_rate * term.number_of_months
    end

    def applicable_rate
      0.02 / 360.0
    end

    private
    def set_depositor_name
      self.depositor_name ||= self.depositor_full_name
    end
  end
end
