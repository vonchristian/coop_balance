module MembershipsModule
  class TimeDeposit < ApplicationRecord
    enum status: [:withdrawn]
    include PgSearch::Model
    pg_search_scope :text_search, against: [:account_number, :depositor_name]

    belongs_to :cooperative
    belongs_to :depositor,                polymorphic: true, touch: true
    belongs_to :office,                   class_name: "Cooperatives::Office"
    belongs_to :time_deposit_product,     class_name: "CoopServicesModule::TimeDepositProduct"
    belongs_to :organization,             optional: true
    belongs_to :barangay,                 optional: true, class_name: "Addresses::Barangay"
    belongs_to :liability_account,        class_name: 'AccountingModule::Account'
    belongs_to :interest_expense_account, class_name: 'AccountingModule::Account'
    belongs_to :break_contract_account,   class_name: 'AccountingModule::Account'
    belongs_to :term
    has_many :ownerships, as: :ownable
    has_many :depositors, through: :ownerships, source: :owner

    delegate :name, :interest_rate, :account, :interest_expense_account, :break_contract_account, :break_contract_fee, to: :time_deposit_product, prefix: true
    delegate :full_name, :first_and_last_name, to: :depositor, prefix: true
    delegate :name, to: :office, prefix: true
    delegate :name, to: :depositor
    delegate :avatar, to: :depositor
    delegate :maturity_date, :effectivity_date, :matured?, to: :term, prefix: true
    delegate :remaining_term, to: :term
    before_save :set_depositor_name
    def self.deposited_on(args={})
      from_date = args[:from_date] || 999.years.ago
      to_date   = args[:to_date]
      date_range = DateRange.new(from_date: from_date, to_date: to_date)
      joins(:terms).where('terms.maturity_date' => date_range.start_date..date_range.end_date)
    end

    def entries
      accounting_entries = []
      liability_account.amounts.each do |amount|
        accounting_entries << amount.entry
      end
      interest_expense_account.amounts.each do |amount|
        accounting_entries << amount.entry
      end
      break_contract_account.amounts.each do |amount|
        accounting_entries << amount.entry
      end
      accounting_entries.uniq
    end

    def can_be_extended?
      !withdrawn? && term_matured?
    end

    def withdrawal_date
      if withdrawn?
        # time_deposit_product_account.debit_entries.select {|e| e.amounts.where(commercial_document: self)}.first.entry_date
        entries.sort_by(&:created_at).reverse.first.entry_date
      end
    end

    def withdrawn?
      withdrawn == true
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
      all.select{|a| a.term_matured? }
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
      balance
    end

    def disbursed?
      true
    end

    def balance(args={})
      liability_account.balance(args)
    end

    def credits_balance(args={})  # deposit amount
      liability_account.credits_balance(args.merge(commercial_document: self))
    end

    def interest_balance(args={})
      interest_expense_account.debits_balance(args.merge(commercial_document: self))
    end

    def deposited_amount
      credits_balance - interest_balance
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
