module AccountingModule
  class Account < ApplicationRecord
    self.inheritance_column = nil
    TYPES = %w[Asset Liability Equity Revenue Expense].freeze
    NORMAL_CREDIT_BALANCE = %w[equity liability revenue].freeze
    include PgSearch::Model

    enum :account_type, {
      asset: "asset",
      liability: "liability",
      equity: "equity",
      revenue: "revenue",
      expense: "expense"
    }

    pg_search_scope :text_search, against: %i[name code]

    belongs_to :ledger, class_name: "AccountingModule::Ledger"
    belongs_to :office, class_name: "Cooperatives::Office"
    has_many :amounts, class_name: "AccountingModule::Amount"
    has_many :credit_amounts,        -> { not_cancelled },        class_name: "AccountingModule::CreditAmount"
    has_many :debit_amounts,         -> { not_cancelled },        class_name: "AccountingModule::DebitAmount"
    has_many :entries,                       through: :amounts, source: :entry, class_name: "AccountingModule::Entry"
    has_many :credit_entries,                through: :credit_amounts, source: :entry, class_name: "AccountingModule::Entry"
    has_many :debit_entries,                 through: :debit_amounts, source: :entry, class_name: "AccountingModule::Entry"
    has_many :running_balances, class_name: "AccountingModule::RunningBalances::Account"

    validates :account_type, :name, :code, presence: true
    validates :name, uniqueness: true

    # remove
    def self.cash_accounts
      Employees::EmployeeCashAccount.cash_accounts
    end

    def self.active
      where(active: true)
    end

    def self.inactive
      where(active: false)
    end

    def self.updated_at(args = {})
      date_range = DateRange.new(from_date: args[:from_date], to_date: args[:to_date])
      joins(:entries).where("entries.entry_date" => date_range.start_date..date_range.end_date)
    end

    def self.updated_by(employee)
      includes(:entries).where("entries.recorder_id" => employee.id)
    end

    def account_name
      name
    end

    def normalized_type
      type.gsub("AccountingModule::", "")
    end

    def self.types
      [ "AccountingModule::Asset",
       "AccountingModule::Equity",
       "AccountingModule::Liability",
       "AccountingModule::Expense",
       "AccountingModule::Revenue" ]
    end

    def self.balance(options = {})
      accounts_balance = BigDecimal("0")
      find_each do |account|
        if  account.normal_credit_balance ^ account.contra?
          accounts_balance -= account.balance(options)
        else
          accounts_balance += account.balance(options)
        end
      end
      accounts_balance
    end

    def self.except_account(args = {})
      where.not(id: args[:account_ids])
    end

    def self.entries(_args = {})
      ids = AccountingModule::Amount.where(account_id: self.ids).pluck(:entry_id)
      AccountingModule::Entry.where(id: ids.uniq.flatten).where(cancelled: false)
    end

    def self.credit_entries(_args = {})
      ids = AccountingModule::CreditAmount.where(account_id: self.ids).pluck(:entry_id)
      AccountingModule::Entry.where(id: ids.uniq.flatten).where(cancelled: false)
    end

    def self.debit_entries(_args = {})
      ids = AccountingModule::DebitAmount.where(account_id: self.ids).pluck(:entry_id)
      AccountingModule::Entry.where(id: ids.uniq.flatten).where(cancelled: false)
    end

    def self.credit_amounts(_args = {})
      AccountingModule::CreditAmount.where(account_id: ids)
    end

    def self.debit_amounts(_args = {})
      AccountingModule::DebitAmount.where(account_id: ids)
    end

    def self.debits_balance(options = {})
      accounts_balance = BigDecimal("0")
      find_each do |account|
        if account.normal_credit_balance ^ account.contra?
          accounts_balance -= account.debits_balance(options)
        else
          accounts_balance += account.debits_balance(options)
        end
      end
      accounts_balance
    end

    def self.credits_balance(options = {})
      accounts_balance = BigDecimal("0")
      find_each do |account|
        if  account.normal_credit_balance ^ account.contra?
          accounts_balance -= account.credits_balance(options)
        else
          accounts_balance += account.credits_balance(options)
        end
      end
      accounts_balance
    end

    def self.trial_balance(args = {})
      AccountingModule::Account.asset.balance(args) - (AccountingModule::Account.liability.balance(args) + AccountingModule::Account.equity.balance(args) + AccountingModule::Account.revenue.balance(args) - AccountingModule::Account.expense.balance(args))
    end

    def self.net_surplus(args = {})
      revenue.balance(args) -
        expenses.balance(args)
    end

    def self.total_equity_and_liabilities(args = {})
      equity.balance(args) +
        liability.balance(args)
    end

    def balance(options = {})
      if normal_credit_balance ^ contra?
        credits_balance(options) - debits_balance(options)
      else
        debits_balance(options) - credits_balance(options)
      end
    end

    def display_name
      ledger.name
    end

    def credits_balance(args = {})
      credit_amounts.balance(args)
    end

    def debits_balance(args = {})
      debit_amounts.balance(args)
    end

    def default_last_transaction_date
      last_transaction_date || updated_at
    end

    def running_balance(entry_date: nil)
      running_balances.balance(entry_date: entry_date)
    end

    def normal_credit_balance
      NORMAL_CREDIT_BALANCE.include?(account_type)
    end
  end
end
