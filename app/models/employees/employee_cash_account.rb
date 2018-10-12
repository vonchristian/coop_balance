module Employees
  class EmployeeCashAccount < ApplicationRecord
    belongs_to :employee, class_name: "User"
    belongs_to :cash_account, class_name: "AccountingModule::Account"
  end
end
