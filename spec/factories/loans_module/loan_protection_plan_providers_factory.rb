FactoryBot.define do
  factory :loan_protection_plan_provider, class: LoansModule::LoanProtectionPlanProvider do
    business_name { Faker::Company.bs }
    rate { 0.75 }
    association :accounts_payable, factory: :asset
    association :cooperative
  end
end
