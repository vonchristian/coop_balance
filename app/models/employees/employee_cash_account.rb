module Employees
  class EmployeeCashAccount < ApplicationRecord
    belongs_to :employee,     class_name: "User"
    belongs_to :cash_account, class_name: "AccountingModule::Account"
    belongs_to :cooperative

    delegate :name, to: :cash_account
    validates :cash_account_id, uniqueness: { scope: :employee_id, message: "Already taken" }
    validate :asset_account?

    def self.cash_accounts
      accounts = pluck(:cash_account_id)
      AccountingModule::Asset.where(id: accounts)
    end

    private
    def asset_account?
      errors[:cash_account_id] << "Must be an asset account" if AccountingModule::Account.find(cash_account_id).type != "AccountingModule::Asset"
    end
  end
end
