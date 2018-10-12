FactoryBot.define do
  factory :employee_cash_account, class: Employees::EmployeeCashAccount do
    employee { nil }
    cash_account { nil }
  end
end
