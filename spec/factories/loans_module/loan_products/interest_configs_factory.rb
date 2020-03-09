FactoryBot.define do
  factory :interest_config, class: LoansModule::LoanProducts::InterestConfig do
    association :loan_product

    calculation_type { 'prededucted' }
    rate { 0.18 }

    factory :prededucted_interest_config do 
      calculation_type { 'prededucted' }
    end

    factory :add_on_interest_config do 
      calculation_type { 'add_on' }
    end
  end
end
