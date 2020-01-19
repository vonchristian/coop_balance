module MembershipsModule
  class Saving < ApplicationRecord
    include PgSearch::Model
    include InactivityMonitoring
    extend  PercentActive
    monetize :averaged_balance_cents, as: :averaged_balance, numericality: true
    pg_search_scope :text_search, against: [:account_number, :account_owner_name]
    multisearchable against: [:account_number, :account_owner_name]

    belongs_to :organization,             optional: true
    belongs_to :cooperative
    belongs_to :barangay,                 optional: true, class_name: "Addresses::Barangay"
    belongs_to :depositor,                polymorphic: true
    belongs_to :liability_account,        class_name: 'AccountingModule::Account'
    belongs_to :interest_expense_account, class_name: 'AccountingModule::Account'
    belongs_to :saving_product,           class_name: "CoopServicesModule::SavingProduct"
    belongs_to :office,                   class_name: "Cooperatives::Office"
    has_many :ownerships,                 as: :ownable
    has_many :member_co_depositors,       through: :ownerships, source: :owner, source_type: "Member"
    has_many :debit_amounts,              class_name: "AccountingModule::DebitAmount", as: :commercial_document
    has_many :credit_amounts,             class_name: "AccountingModule::CreditAmount", as: :commercial_document
    has_many :ownerships,                 as: :ownable
    has_many :member_depositors,          through: :ownerships, source: :owner, source_type: 'Member'
    has_many :organization_depositors,    through: :ownerships, source: :owner, source_type: 'Organization'
    has_many :accountable_accounts,       class_name: 'AccountingModule::AccountableAccount', as: :accountable
    has_many :accounts,                   through: :accountable_accounts, class_name: 'AccountingModule::Account'
    has_many :entries,                    through: :accounts, class_name: 'AccountingModule::Entry'
    has_many :savings_account_agings,     class_name: 'SavingsModule::SavingsAccountAging', foreign_key: 'savings_account_id'
    has_many :savings_aging_groups,       through: :savings_account_agings 

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
    delegate :name, to: :liability_account, prefix: true
    delegate :name, to: :interest_expense_account, prefix: true
    delegate :avatar, to: :depositor, allow_nil: true
    delegate :dormancy_number_of_days, :balance_averager, to: :saving_product
    delegate :balance, :debits_balance, :credits_balance, to: :liability_account
    delegate :title, to: :current_aging_group, prefix: true, allow_nil: true
    validates :depositor, presence: true


    before_save :set_account_owner_name, :set_date_opened #move to saving opening

    has_many :amounts,  class_name: "AccountingModule::Amount", as: :commercial_document
    
    def current_aging_group
      savings_aging_groups.current 
    end 

    def self.can_earn_interest 
      where(can_earn_interest: true)
    end 
    

    def self.liability_accounts
      ids = pluck(:liability_account_id)
      AccountingModule::Liability.where(id: ids)
    end


    def self.interest_expense_accounts
      ids = pluck(:interest_expense_account_id)
      AccountingModule::Expense.where(id: ids)
    end

    def self.total_balances(args={})
      liability_accounts.balance(args)
    end

    def depositors
      member_depositors + organization_depositors
    end

    def self.below_minimum_balance
      where(has_minimum_balance: false)
    end
    def self.has_minimum_balances
      where(has_minimum_balance: true)
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
      interest_expense_account.
      entries.
      entered_on(from_date: args[:from_date].beginning_of_quarter, to_date: args[:to_date].end_of_quarter).present?
    end

    def self.updated_at(args={})
      if args[:from_date] && args[:to_date]
        date_range = DateRange.new(from_date: args[:from_date], to_date: args[:to_date])
        joins(:entries).where('entries.entry_date' => (date_range.start_date..date_range.end_date))
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



    def balance_for(args={})

    end

    def deposits(args = {})
      credits_balance(args)
    end

    def withdrawals(args = {})
      debits_balance(args)
    end

    def interests_earned(args={})
      interest_expense_account.debits_balance(commercial_document: self, from_date: args[:from_date], to_date: args[:to_date])
    end

    def can_withdraw?
      !closed? && balance > 0.0
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
