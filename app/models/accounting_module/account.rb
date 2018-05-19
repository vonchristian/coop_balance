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

    def self.active
      where(active: true)
    end
    def self.inactive
      where.not(active: true)
    end
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
      if self.new.class == AccountingModule::Account
        raise(NoMethodError, "undefined method 'balance'")
      else
        accounts_balance = BigDecimal.new('0')
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
    end
    def self.trial_balance
      if self.new.class == AccountingModule::Account
        AccountingModule::Asset.balance - (AccountingModule::Liability.balance + AccountingModule::Equity.balance + AccountingModule::Revenue.balance - AccountingModule::Expense.balance)
      else
        raise(NoMethodError, "undefined method 'trial_balance'")
      end
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
    def credits_balance(options={})
      credit_amounts.balance(options)
    end
    def debits_balance(options={})
      debit_amounts.balance(options)
    end
  end
end
