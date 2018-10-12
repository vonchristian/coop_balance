class EmployeeCashAccount < ApplicationRecord
  belongs_to :employee
  belongs_to :cash_account
end
