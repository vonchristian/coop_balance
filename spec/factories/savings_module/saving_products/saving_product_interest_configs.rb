FactoryBot.define do
  factory :saving_product_interest_config, class: SavingsModule::SavingProducts::SavingProductInterestConfig do
    association :interest_expense_category, factory: :expense_level_one_account_category  
    association :saving_product 
    interest_posting { 'annually' }
    annual_rate      { 0.03 }
    minimum_balance  { 500 }
  end 
end
