FactoryBot.define do
  factory :loan_product, class: 'LoansModule::LoanProduct' do
    name { "#{Faker::Company.bs}-#{SecureRandom.uuid}" }
    cooperative
    office
    amortization_type
    interest_amortization
    total_repayment_amortization
    maximum_loanable_amount { 100_000_000 }
  end
end
