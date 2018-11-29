module MembershipsModule
  class Saving < ApplicationRecord
    include PgSearch
    include InactivityMonitoring

    pg_search_scope :text_search, against: [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]

    belongs_to :cooperative
    belongs_to :cart, optional: true, class_name: "StoreFrontModule::Cart"
    belongs_to :barangay, optional: true, class_name: "Addresses::Barangay"
    belongs_to :depositor,        polymorphic: true,  touch: true
    has_many :ownerships, as: :ownable
    has_many :member_co_depositors, through: :ownerships, source: :owner, source_type: "Member"

    belongs_to :saving_product,   class_name: "CoopServicesModule::SavingProduct"
    belongs_to :office,           class_name: "CoopConfigurationsModule::Office"
    has_many :debit_amounts,      class_name: "AccountingModule::DebitAmount", as: :commercial_document
    has_many :credit_amounts,      class_name: "AccountingModule::CreditAmount", as: :commercial_document

    delegate :name, :current_occupation, to: :depositor, prefix: true
    delegate :name,
             :closing_account,
             :closing_account_fee,
             :account,
             :closing_account,
             :interest_rate,
             :quarterly_interest_rate,
             :interest_expense_account, to: :saving_product, prefix: true
    delegate :name, to: :office, prefix: true, allow_nil: true
    delegate :name, to: :depositor, prefix: true
    delegate :name, to: :barangay, prefix: true, allow_nil: true

    delegate :avatar, to: :depositor, allow_nil: true
    delegate :dormancy_number_of_days, to: :saving_product

    validates :depositor, presence: true

    scope :has_minimum_balance, -> { SavingsQuery.new.has_minimum_balance  }

    before_save :set_account_owner_name, :set_date_opened #move to saving opening


    def self.below_minimum_balance
      where(has_minimum_balance: false)
    end

    def self.inactive(args={})
      updated_at(args)
    end

    def entries
      accounting_entries = []
      saving_product_account.amounts.includes(:entry => [:credit_amounts]).where(commercial_document: self).each do |amount|
        accounting_entries << amount.entry
      end
      saving_product_interest_expense_account.amounts.includes(:entry =>[:credit_amounts]).where(commercial_document: self).each do |amount|
        accounting_entries << amount.entry
      end
      accounting_entries.uniq
    end
    def closed?
      saving_product_closing_account.amounts.where(commercial_document: self).present?
    end

    def dormant?
      dormancy_number_of_days < number_of_days_inactive
    end

    def interest_posted?(args={})
      saving_product.
      interest_expense_account.
      credit_amounts.
      entries_for(commercial_document: self).
      entered_on(from_date: args[:from_date].beginning_of_quarter, to_date: args[:to_date].end_of_quarter).present?
    end

    def self.updated_at(args={})
      if args[:from_date] && args[:to_date]
        date_range = DateRange.new(from_date: args[:from_date], to_date: args[:to_date])
        where('last_transaction_date' => (date_range.start_date..date_range.end_date))
      else
        all
      end
    end

    def self.top_savers(args={})
      limiting_num = args[:limiting_num] || 10
      all.to_a.sort_by(&:balance).reverse.first(limiting_num)
    end

    def name
      depositor_name
    end
    def name_and_balance
      "#{name} - #{balance.to_f}"
    end
    def post_interests_earned(date)
      InterestPosting.new.post_interests_earned(self, date)
    end

    def balance(args={})
      from_date = args[:from_date] || Date.today - 999.years
      to_date   = args[:to_date] || Date.today + 999.years
      saving_product_account.balance(commercial_document: self, from_date: from_date, to_date: to_date)
    end

    def deposits
      saving_product_account.credits_balance(commercial_document: self)
    end
    def withdrawals
      saving_product_account.debits_balance(commercial_document: self)
    end

    def interests_earned(args={})
      saving_product_interest_expense_account.debits_balance(commercial_document: self, from_date: args[:from_date], to_date: args[:to_date])
    end

    def can_withdraw?
      !closed? && balance > 0.0
    end


    def average_daily_balance(args={})
      balances = []
      date_range = args[:date].beginning_of_quarter..args[:date].end_of_quarter
      (date_range).each do |date|
        daily_balance = saving_product.balance(commercial_document: self, from_date: self.first_transaction_date, to_date: date.end_of_day)
        balances << daily_balance
      end

      balances.sum / 365
    end

    private
    def check_balance
      if balance >= saving_product.minimum_balance
        self.update_attributes!(has_minimum_balance:  true)
      elsif balance < saving_product.minimum_balance
        self.update_attributes!(has_minimum_balance:  false)
      end
    end

    def set_account_owner_name
      self.account_owner_name = self.depositor_name # depositor is polymorphic
    end
    def set_date_opened
      todays_date = ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
      self.date_opened ||= todays_date
    end
  end
end
