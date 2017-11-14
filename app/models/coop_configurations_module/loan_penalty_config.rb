module CoopConfigurationsModule
  class LoanPenaltyConfig < ApplicationRecord
    DEFAULT_RATE = 0.02
    #Model to set configs for loan penalties
    belongs_to :account, class_name: "AccountingModule::Account"
    validates :interest_rate, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
    validates :number_of_days, presence: true, numericality: true
    def self.default_rate
      if self.exists?
        order(created_at: :asc).last.interest_rate
      else
        DEFAULT_RATE
      end
    end
    def self.account_to_debit
      if self.exists?
        order(created_at: :asc).last.account
      else
        AccountingModule::Account.find_by(name: "Loan Penalties")
      end
    end
    def self.balance_for(borrower)
      account_to_debit.balance(commercial_document_id: borrower.id)
    end
  end
end
