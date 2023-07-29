# frozen_string_literal: true 

module AccountingModule 
  class Ledger < ApplicationRecord
    NORMAL_CREDIT_BALANCE = ['equity', 'liability', 'revenue'].freeze
    has_ancestry

    enum account_type: {
      asset: 'asset',
      liability: 'liability',
      equity: 'equity',
      revenue: 'revenue',
      expense: 'expense'
    }

    has_many :accounts, class_name: 'AccountingModule::Account'
    has_many :credit_amounts,        -> { not_cancelled }, :class_name => 'AccountingModule::CreditAmount', through: :accounts
    has_many :debit_amounts,         -> { not_cancelled }, :class_name => 'AccountingModule::DebitAmount', through: :accounts
    
    def subsidiary_ledgers
      children
    end

    def self.balance(options={})
      accounts_balance = BigDecimal('0')
      self.all.each do |ledger|
        if ledger.contra?
          accounts_balance -= ledger.balance(options)
        else
          accounts_balance += ledger.balance(options)
        end
      end
      accounts_balance
    end

    def balance(options={})
      return descendants.balance(options) if descendants.present? 

      if normal_credit_balance ^ contra?
        credits_balance(options) - debits_balance(options)
      else
        debits_balance(options) - credits_balance(options)
      end
    end

    def credits_balance(args={})
      credit_amounts.balance(args)
    end

    def debits_balance(args={})
      debit_amounts.balance(args)
    end

    def normal_credit_balance
      NORMAL_CREDIT_BALANCE.include?(account_type)
    end
  end
end
