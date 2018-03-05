FactoryBot.define do
  factory :penalty_config do
    loan_product nil
    rate "9.99"
    penalty_receivable_account nil
    penalty_revenue_account nil
  end
end
