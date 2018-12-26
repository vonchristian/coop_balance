module AccountingModule
  class Account < ApplicationRecord
    include PgSearch
    extend ProfitPercentage
    pg_search_scope :text_search, :against => [:name, :code]
    multisearchable against: [:name, :code]

    class_attribute :normal_credit_balance

    belongs_to :main_account,       class_name: "AccountingModule::Account", foreign_key: 'main_account_id'
    has_many :amounts,              class_name: "AccountingModule::Amount"
    has_many :credit_amounts,       :extend => AccountingModule::BalanceFinder, :class_name => 'AccountingModule::CreditAmount'
    has_many :debit_amounts,        :extend => AccountingModule::BalanceFinder, :class_name => 'AccountingModule::DebitAmount'
    has_many :entries,              through: :amounts, source: :entry, class_name: "AccountingModule::Entry"
    has_many :credit_entries,       :through => :credit_amounts, :source => :entry, :class_name => 'AccountingModule::Entry'
    has_many :debit_entries,        :through => :debit_amounts, :source => :entry, :class_name => 'AccountingModule::Entry'
    has_many :subsidiary_accounts,  class_name: "AccountingModule::Account", foreign_key: 'main_account_id'
    has_many :account_budgets

    validates :type, :name, :code, presence: true
    validates :name, uniqueness: true
    validates :code, uniqueness: { case_sensitive: false }

    scope :assets,      -> { where(type: 'AccountingModule::Asset') }
    scope :liabilities, -> { where(type: 'AccountingModule::Liability') }
    scope :equities,    -> { where(type: 'AccountingModule::Equity') }
    scope :revenues,    -> { where(type: 'AccountingModule::Revenue') }
    scope :expenses,    -> { where(type: 'AccountingModule::Expense') }

    def self.cash_accounts
      Employees::EmployeeCashAccount.cash_accounts
    end

    def self.active
      where(active: true)
    end

    def self.inactive
      where(active: false)
    end

    def self.updated_at(args={})
      if args[:from_date] && args[:to_date]
        date_range = DateRange.new(from_date: args[:from_date], to_date: args[:to_date])
        where('last_transaction_date' => date_range.start_date..date_range.end_date)
      end
    end

    def self.updated_by(employee)
      includes(:entries).where('entries.recorder_id' => employee.id)
    end

    def account_name
      name
    end

    def set_as_inactive
      if balance.zero?
        self.update_attributes!(active: false)
      else
        false
      end
    end


    def normalized_type
      type.gsub("AccountingModule::", "")
    end

    def self.types
      ["AccountingModule::Asset",
       "AccountingModule::Equity",
       "AccountingModule::Liability",
       "AccountingModule::Expense",
       "AccountingModule::Revenue"]
     end

    def self.balance(options={})
      accounts_balance = BigDecimal('0')
      accounts = self.all
      accounts.each do |account|
        if account.contra
          accounts_balance -= account.balance(options)
        else
          accounts_balance += account.balance(options)
        end
      end
      accounts_balance
    end

    def self.except_account(args={})
      accounts = args[:account]
      where.not(id: accounts)
    end

    def self.entries(args={})
      ids = AccountingModule::Amount.for_account(account_id: self.pluck(:id)).pluck(:entry_id)
      AccountingModule::Entry.where(id: ids)
    end

    def self.credit_entries(args={})
      ids = AccountingModule::CreditAmount.for_account(account_id: self.pluck(:id)).pluck(:entry_id)
      AccountingModule::Entry.where(id: ids)
    end

    def self.debit_entries(args={})
      ids = AccountingModule::DebitAmount.for_account(account_id: self.pluck(:id)).pluck(:entry_id)
      AccountingModule::Entry.where(id: ids)
    end

    def self.credit_amounts(args={})
      AccountingModule::CreditAmount.where(account_id: pluck(:id))
    end

    def self.debit_amounts(args={})
      AccountingModule::DebitAmount.where(account_id: pluck(:id))
    end

    def self.debits_balance(options={})
      accounts_balance = BigDecimal('0')
      accounts = self.all
      accounts.each do |account|
        if account.contra
          accounts_balance -= account.debits_balance(options)
        else
          accounts_balance += account.debits_balance(options)
        end
      end
      accounts_balance
    end

    def self.credits_balance(options={})
      accounts_balance = BigDecimal('0')
      accounts = self.all
      accounts.each do |account|
        if account.contra
          accounts_balance -= account.credits_balance(options)
        else
          accounts_balance += account.credits_balance(options)
        end
      end
      accounts_balance
    end

    def self.trial_balance(args={})
      if self.new.class == AccountingModule::Account
        assets.balance(args) - (liabilities.balance(args) + equities.balance(args) + revenues.balance(args) - expenses.balance(args))
      else
        raise(NoMethodError, "undefined method 'trial_balance'")
      end
    end

    def self.net_surplus(args={})
      revenues.balance(args) -
      expenses.balance(args)
    end

    def self.total_equity_and_liabilities(args={})
      equities.balance(args) +
      liabilities.balance(args)
    end


    def balance(options={})
      if self.class == AccountingModule::Account
        raise(NoMethodError, "undefined method 'balance'")
      else
        if self.normal_credit_balance ^ contra
          credits_balance(options) - debits_balance(options)
        else
          debits_balance(options) - credits_balance(options)
        end
      end
    end

    def credits_balance(args={})
      credit_amounts.balance(args)
    end

    def debits_balance(args={})
      debit_amounts.balance(args)
    end

    def current_account_budget
      account_budgets.current
    end
    def default_last_transaction_date
      last_transaction_date || updated_at
    end
  end
end
