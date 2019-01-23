module MembershipsModule
  class Saving < ApplicationRecord
    include PgSearch
    include InactivityMonitoring
    extend  PercentActive

    pg_search_scope :text_search, against: [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]

    belongs_to :cooperative
    belongs_to :cart, optional: true, class_name: "StoreFrontModule::Cart"
    belongs_to :barangay, optional: true, class_name: "Addresses::Barangay"
    belongs_to :depositor,        polymorphic: true,  touch: true
    has_many :ownerships, as: :ownable
    has_many :member_co_depositors, through: :ownerships, source: :owner, source_type: "Member"
    belongs_to :organization

    belongs_to :saving_product,   class_name: "CoopServicesModule::SavingProduct"
    belongs_to :office,           class_name: "CoopConfigurationsModule::Office"
    has_many :debit_amounts,      class_name: "AccountingModule::DebitAmount", as: :commercial_document
    has_many :credit_amounts,      class_name: "AccountingModule::CreditAmount", as: :commercial_document

    delegate :name, :current_address_complete_address, :current_contact_number, :current_occupation, to: :depositor, prefix: true
    delegate :name,
             :applicable_rate,
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
    delegate :dormancy_number_of_days, :balance_averager, to: :saving_product

    validates :depositor, presence: true


    before_save :set_account_owner_name, :set_date_opened #move to saving opening

    has_many :amounts,  class_name: "AccountingModule::Amount", as: :commercial_document
    has_many :entries,  through: :amounts, class_name: "AccountingModule::Entry"

    def self.below_minimum_balance
      where(has_minimum_balance: false)
    end
    def self.has_minimum_balances
      where(has_minimum_balance: true)
    end

    def self.averaged_balance(args={})
      ids = pluck(:id)
      balances = []
      months   = []
      (args[:from_date]..args[:to_date]).each do |date|
        months << date.end_of_month
      end

      months.uniq.each do |month|
        balances << CoopServicesModule::SavingProduct.total_balance(commercial_document: ids, to_date: month.end_of_month).to_f
      end
      balances.sum
    end

    def self.inactive(args={})
      updated_at(args)
    end

    def self.balance(args={})
      ids = pluck(:id)
      CoopServicesModule::SavingProduct.total_balance(args.merge(commercial_document: ids))
    end

    # def entries
    #   entry_ids = []
    #   entry_ids << saving_product_account.amounts.where(commercial_document: self).pluck(:entry_id)
    #   entry_ids << saving_product_interest_expense_account.amounts.where(commercial_document: self).pluck(:entry_id)
    #   AccountingModule::Entry.where(id: entry_ids.uniq.flatten)
    # end

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

    def balance(args={})
      saving_product_account.balance(args.merge(commercial_document: self))
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


    def averaged_balance(args={})
      balance_averager.new(saving: self, to_date: args[:to_date]).averaged_balance
    end

    def computed_interest(args={})
      averaged_balance(to_date: args[:to_date]) * saving_product_applicable_rate
    end

    private
    def set_account_owner_name
      self.account_owner_name = self.depositor_name # depositor is polymorphic
    end

    def set_date_opened
      todays_date = ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
      self.date_opened ||= todays_date
    end
  end
end
