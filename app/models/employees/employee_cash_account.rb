module Employees
  class EmployeeCashAccount < ApplicationRecord
    belongs_to :employee, class_name: "User"
    belongs_to :cash_account, class_name: "AccountingModule::Account"
    delegate :name, to: :cash_account
    validates :cash_account_id, uniqueness: { scope: :employee_id }

    def self.cash_accounts
      ids = pluck(:cash_account_id)
      AccountingModule::Asset.where(id: ids)
    end
  end
end
