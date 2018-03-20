FactoryBot.define do
  factory :loan_product, class: "LoansModule::LoanProduct" do
      sequence(:name) { |n| "loan_product " +  ('a'..'z').to_a.shuffle.join }
    description "MyString"
    maximum_loanable_amount 1_000_000
    association :loans_receivable_current_account, factory: :asset
    association :loans_receivable_past_due_account, factory: :asset
    factory :loan_product_with_interest_config, class: LoansModule::LoanProduct do |loan_product|
      loan_product.after(:build) do |t|
        t.interest_configs << create(:interest_config)
      end
    end
  end
end

