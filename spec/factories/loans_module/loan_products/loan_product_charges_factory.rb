FactoryBot.define do
  factory :loan_product_charge, class: 'LoansModule::LoanProducts::Charge' do
    loan_product
    account factory: %i[revenue]
    name        { Faker::Company.name }
    rate        { 0.2 }
    charge_type { 'amount_based' }
    amount      { 100 }
  end
end
