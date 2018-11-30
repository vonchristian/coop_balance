FactoryBot.define do
  factory :employee_cash_account, class: Employees::EmployeeCashAccount do
    association :employee, factory: :user
    association :cash_account, factory: :asset
    default_account { false }
  end
end
