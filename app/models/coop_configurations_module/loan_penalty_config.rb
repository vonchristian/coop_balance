module CoopConfigurationsModule
  class LoanPenaltyConfig < ApplicationRecord
    #Model to set configs for loan penalties
    belongs_to :account, class_name: "AccountingModule::Account"
    validates :interest_rate, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
    validates :number_of_days, presence: true, numericality: true
    def self.account_to_debit
      if self.exists?
        order(created_at: :asc).last.account
      else
        AccountingModule::Account.find_by(name: "Loan Penalties")
      end
    end
    def self.balance_for(borrower)
      if self.last.present?
        self.order(created_at: :asc).last.account.balance(commercial_document_id: borrower.id)
      else
        AccountingModule::Account.find_by(name: "Loan Penalties").balance(commercial_document_id: borrower.id)
      end
    end
  end
end
