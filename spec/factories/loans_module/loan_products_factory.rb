FactoryBot.define do
  factory :loan_product, class: "LoansModule::LoanProduct" do |product|
    product.name { Faker::Company.name }
    product.description { "MyString" }
    product.maximum_loanable_amount { 1_000_000 }
    product.association :current_account, factory: :asset
    product.association :past_due_account, factory: :asset
    product.association :restructured_account, factory: :asset

    factory :loan_product_with_interest_and_penalty_account do
      product.after(:build) do |t|
        t.interest_configs << create(:interest_config)
        t.penalty_configs << create(:penalty_config)
      end
    end
    factory :add_on_straight_line_loan_product, class: "LoansModule::LoanProduct" do |product|
      product.association :amortization_type, factory: :straight_line_amortization_type
      product.after(:build) do |p|
        p.interest_configs << create(:add_on_interest_config)
      end
    end
    factory :accrued_straight_line_loan_product, class: "LoansModule::LoanProduct" do |product|
      product.association :amortization_type, factory: :straight_line_amortization_type
      product.after(:build) do |p|
        p.interest_configs << create(:accrued_interest_config)
      end
    end
  end
end
