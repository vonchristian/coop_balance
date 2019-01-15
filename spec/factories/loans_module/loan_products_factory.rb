FactoryBot.define do
  factory :loan_product, class: "LoansModule::LoanProduct" do |product|
    product.name { Faker::Company.name }
    product.description { "MyString" }
    product.maximum_loanable_amount { 1_000_000 }
    product.association :current_account, factory: :asset
    product.association :past_due_account, factory: :asset
    product.association :restructured_account, factory: :asset

    product.after(:build) do |t|
      t.interest_configs << create(:interest_config)
      t.penalty_configs << create(:penalty_config)
    end
  end
end
