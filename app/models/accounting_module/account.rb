module AccountingModule
  class Account < ApplicationRecord
    include PgSearch 
    pg_search_scope :text_search, :against => [:name, :code]

    WAREHOUSE_ACCOUNTS= ["Raw Materials Inventory",
                          "Raw Materials Inventory",
                          "Work in Process Inventory",
                          "Finished Goods Inventory",
                          "Cash on Hand",
                          "Accounts Receivables Trade - Current",
                          "Accounts Payable-Trade",
                          "Raw Material Purchases",
                          'Purchase Returns and Allowances',
                          'Purchase Discounts',
                          'Freight In',
                          'Direct Labor',
                          'Factory/Processing Overhead',
                          'Sales']

    class_attribute :normal_credit_balance

    has_many :amounts, class_name: "AccountingModule::Amount"
    has_many :credit_amounts, :extend => AmountsExtension, :class_name => 'AccountingModule::CreditAmount'
    has_many :debit_amounts, :extend => AmountsExtension, :class_name => 'AccountingModule::DebitAmount'
    has_many :entries, through: :amounts, source: :entry
    has_many :credit_entries, :through => :credit_amounts, :source => :entry, :class_name => 'AccountingModule::Entry'
    has_many :debit_entries, :through => :debit_amounts, :source => :entry, :class_name => 'AccountingModule::Entry'

    validates :type, presence: true
    validates :name, :code, presence: true, uniqueness: true
    def account_name 
      name 
    end
    def self.warehouse_accounts
      all.select{ |a| WAREHOUSE_ACCOUNTS.include?(a.name) }
    end

    def self.active
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
