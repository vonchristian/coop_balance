module CoopConfigurationsModule
  class LoanInterestConfig < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"
    validates :account_id, presence: true
    def self.account_to_debit
      if self.exists?
        order(created_at: :asc).last.account
      else
        AccountingModule::Account.find_by(name: "Interest Income from Loans")
      end
    end
  end
end
