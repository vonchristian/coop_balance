FactoryBot.define do
  factory :penalty_config, class: LoansModule::LoanProducts::PenaltyConfig do
    association :loan_product
    association :penalty_revenue_account, factory: :revenue
    rate { 0.02 }
  end
end
