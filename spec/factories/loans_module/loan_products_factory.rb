FactoryBot.define do
  factory :loan_product, class: 'LoansModule::LoanProduct' do
    name { Faker::Company.bs }
    association :current_account, factory: :asset
    association :past_due_account, factory: :asset
    maximum_loanable_amount { 100_000_000 }
  end
end
