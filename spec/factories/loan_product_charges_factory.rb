FactoryBot.define do
  factory :loan_product_charge, class: LoansModule::LoanProducts::LoanProductCharge do
    loan_product { nil }
    name { Faker::Name.name }
    amount { 100 }
    rate   { 0.03 }
    association :account, factory: :revenue
  end
end
