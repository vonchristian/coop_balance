FactoryBot.define do
  factory :loan_product, class: 'LoansModule::LoanProduct' do
    name { Faker::Company.bs }
    association :current_account, factory: :asset
    association :past_due_account, factory: :asset
    maximum_loanable_amount { 100_000_000 }
    after(:build) do |t|
      create(:interest_config, loan_product: t)
      create(:penalty_config, loan_product: t)
    end
  end
end
