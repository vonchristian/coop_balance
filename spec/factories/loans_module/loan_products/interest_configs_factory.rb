FactoryBot.define do
  factory :interest_config, class: LoansModule::LoanProducts::InterestConfig do
    association :loan_product
    association :interest_revenue_account, factory: :revenue
    association :unearned_interest_income_account, factory: :revenue
    association :accrued_income_account, factory: :asset
    association :past_due_interest_income_account, factory: :revenue
    association :cooperative
    calculation_type { 'prededucted' }
    rate { 0.18 }

    factory :accrued_interest_config do 
      calculation_type { 'accrued' }
    end

    factory :prededucted_interest_config do 
      calculation_type { 'prededucted' }
    end

    factory :add_on_interest_config do 
      calculation_type { 'add_on' }
    end
  end
end
