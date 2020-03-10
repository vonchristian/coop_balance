FactoryBot.define do 
  factory :loan_product_charge, class: LoansModule::LoanProducts::LoanProductCharge do 
    association :loan_product
    association :account, factory: :revenue
    name        { Faker::Company.name }
    rate        { 0.2 }
    charge_type { 'amount_based' }
    amount      { 100 }
  end 
end 
