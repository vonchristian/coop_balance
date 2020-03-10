FactoryBot.define do
  factory :loan_product, class: 'LoansModule::LoanProduct' do
    name                    { "#{Faker::Company.bs}-#{SecureRandom.uuid}" }
    association             :cooperative
    association             :office
    association             :amortization_type
    association             :interest_amortization
    association             :total_repayment_amortization
    maximum_loanable_amount { 100_000_000 }
  end
end
