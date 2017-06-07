module AccountingDepartment
  class Account < ApplicationRecord
    class_attribute :normal_credit_balance

    has_many :amounts, class_name: "AccountingDepartment::Amount"
    has_many :credit_amounts, :extend => AmountsExtension, :class_name => 'AccountingDepartment::CreditAmount'
    has_many :debit_amounts, :extend => AmountsExtension, :class_name => 'AccountingDepartment::DebitAmount'
    has_many :entries, through: :amounts, source: :entry
    has_many :credit_entries, :through => :credit_amounts, :source => :entry, :class_name => 'AccountingDepartment::Entry'
    has_many :debit_entries, :through => :debit_amounts, :source => :entry, :class_name => 'AccountingDepartment::Entry'

    validates :type, presence: true
    validates :name, :code, presence: true, uniqueness: true

    def self.active
    end
    def self.types
      ["AccountingDepartment::Asset",
       "AccountingDepartment::Equity",
       "AccountingDepartment::Liability",
       "AccountingDepartment::Expense",
       "AccountingDepartment::Revenue"]
     end
    def self.balance(options={})
      if self.new.class == AccountingDepartment::Account
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
      if self.new.class == AccountingDepartment::Account
        AccountingDepartment::Asset.balance - (AccountingDepartment::Liability.balance + AccountingDepartment::Equity.balance + AccountingDepartment::Revenue.balance - AccountingDepartment::Expense.balance)
      else
        raise(NoMethodError, "undefined method 'trial_balance'")
      end
    end

    def balance(options={})
      if self.class == AccountingDepartment::Account
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
