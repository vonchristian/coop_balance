FactoryBot.define do
  factory :employee_cash_account, class: Employees::EmployeeCashAccount do
    association :cash_account, factory: :asset
    association :employee, factory: :teller
  end
end
