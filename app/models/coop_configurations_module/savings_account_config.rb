module CoopConfigurationsModule
  class SavingsAccountConfig < ApplicationRecord
    validates :closing_account_fee, numericality: true, presence: true

    def default_interest_account
      if interest_account.present?
        interest_account
      else
        AccountingDepartment::Account.find_by(name: "Interest Expense on Deposits")
      end
    end
  end
end
