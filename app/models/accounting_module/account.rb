module AccountingModule
  class Account < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:name, :code]
    multisearchable against: [:name, :code]

    class_attribute :normal_credit_balance

    belongs_to :main_account,       class_name: "AccountingModule::Account", foreign_key: 'main_account_id'
    has_many :amounts,              class_name: "AccountingModule::Amount"
    has_many :credit_amounts,       :class_name => 'AccountingModule::CreditAmount'
    has_many :debit_amounts,        :class_name => 'AccountingModule::DebitAmount'
    has_many :entries,              through: :amounts, source: :entry
    has_many :credit_entries,       :through => :credit_amounts, :source => :entry, :class_name => 'AccountingModule::Entry'
    has_many :debit_entries,        :through => :debit_amounts, :source => :entry, :class_name => 'AccountingModule::Entry'
    has_many :subsidiary_accounts,  class_name: "AccountingModule::Account", foreign_key: 'main_account_id'

    validates :type, :name, :code, presence: true
    validates :name, uniqueness: true
    validates :code, uniqueness: { case_sensitive: false }

    scope :assets,      -> { where(type: 'AccountingModule::Asset') }
    scope :liabilities, -> { where(type: 'AccountingModule::Liability') }
    scope :equities,    -> { where(type: 'AccountingModule::Equity') }
    scope :revenues,    -> { where(type: 'AccountingModule::Revenue') }
    scope :expenses,    -> { where(type: 'AccountingModule::Expense') }
    scope :active,      -> { where(active: true) }

    def self.updated_at(options={})
      if options[:from_date] && options[:to_date]
        date_range = DateRange.new(from_date: options[:from_date], to_date: options[:to_date])
        where('updated_at' => (date_range.start_date)..(date_range.end_date))
      end
    end

    def self.updated_by(employee)
      includes(:entries).where('entries.recorder_id' => employee.id)
    end

    def account_name
      name
    end

    def self.types
      ["AccountingModule::Asset",
       "AccountingModule::Equity",
       "AccountingModule::Liability",
       "AccountingModule::Expense",
       "AccountingModule::Revenue"]
     end

    def self.balance(options={})
      return raise(NoMethodError, "undefined method 'balance'") if self.new.class == AccountingModule::Account
      accounts_balance = BigDecimal.new('0')
      self.all.each do |account|
        if account.contra?
          accounts_balance -= account.balance(options)
        else
          accounts_balance += account.balance(options)
        end
      end
      accounts_balance
    end
    def self.credits_balance(options={})
      return raise(NoMethodError, "undefined method 'credits balance'") if self.new.class == AccountingModule::Account
      accounts_balance = BigDecimal.new('0')
      self.all.each do |account|
        if account.contra?
          accounts_balance -= account.credits_balance(options)
        else
          accounts_balance += account.credits_balance(options)
        end
      end
      accounts_balance
    end
    def self.debits_balance(options={})
      return raise(NoMethodError, "undefined method 'credits balance'") if self.new.class == AccountingModule::Account
      accounts_balance = BigDecimal.new('0')
      self.all.each do |account|
        if account.contra?
          accounts_balance -= account.debits_balance(options)
        else
          accounts_balance += account.debits_balance(options)
        end
      end
      accounts_balance
    end

    def self.trial_balance
      return raise(NoMethodError, "undefined method 'trial_balance'") if self.new.class != AccountingModule::Account
      AccountingModule::Asset.balance -
      ( AccountingModule::Liability.balance +
        AccountingModule::Equity.balance +
        AccountingModule::Revenue.balance -
        AccountingModule::Expense.balance
      )
    end

    def balance(options={})
      return raise(NoMethodError, "undefined method 'balance'") if self.class == AccountingModule::Account
      if self.normal_credit_balance ^ contra
        credits_balance(options) - debits_balance(options)
      else
        debits_balance(options) - credits_balance(options)
      end
    end

    def credits_balance(options={})
      return raise(NoMethodError, "undefined method 'balance'") if self.class == AccountingModule::Account
      if subsidiary_accounts.present?
        balance  = []
        subsidiary_accounts.each do |sub_account|
          balance << sub_account.credit_amounts.balance(options)
        end
        balance.sum
      else
        credit_amounts.balance(options)
      end
    end
    def debits_balance(options={})
      return raise(NoMethodError, "undefined method 'balance'") if self.class == AccountingModule::Account
      if subsidiary_accounts.present?
        subsidiary_accounts.map{ |a| a.debit_amounts.balance(options) }.sum + debit_amounts.balance(options)
      else
        debit_amounts.balance(options)
      end
    end
  end
end
