module CoopConfigurationsModule
  class AccountReceivableStoreConfig < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"
    validates :account_id, presence: true

    def self.balance_for(customer)
      if self.last.present?
        self.order(created_at: :asc).last.account.balance(commercial_document_id: customer.id)
      else
        AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current (General Merchandise)").balance(commercial_document_id: customer.id)
      end
    end
    def self.debit_balance_for(customer)
      if self.last.present?
        self.order(created_at: :asc).last.account.debits_balance(commercial_document_id: customer.id)
      else
        AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current (General Merchandise)").debits_balance(commercial_document: customer.id)
      end
    end
    def self.credit_balance_for(customer)
      if self.last.present?
        self.order(created_at: :asc).last.account.credits_balance(commercial_document_id: customer.id)
      else
        AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current (General Merchandise)").credits_balance(commercial_document: customer.id)
      end
    end

    def self.account_to_debit
      if self.last.present?
       self.order(created_at: :asc).last.account
      else
        AccountingModule::Account.find_by(name: "Accounts Receivables Trade - Current (General Merchandise)")
      end
    end
  end
end
