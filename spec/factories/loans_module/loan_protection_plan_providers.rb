FactoryBot.define do
  factory :loan_protection_plan_provider, class: LoansModule::LoanProtectionPlanProvider do
    business_name { "MyString" }
    cooperative { nil }
    accounts_payable { nil }
  end
end
