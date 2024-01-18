FactoryBot.define do
  factory :loan_protection_plan_provider, class: 'LoansModule::LoanProtectionPlanProvider' do
    business_name { Faker::Company.bs }
    rate { 0.75 }
    accounts_payable factory: %i[asset]
    cooperative
  end
end
