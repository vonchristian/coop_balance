FactoryBot.define do
  factory :employee_cash_account, class: 'Employees::EmployeeCashAccount' do
    cash_account factory: %i[asset]
    employee factory: %i[teller]
  end
end
