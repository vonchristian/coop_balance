FactoryBot.define do
  factory :interest_amortization, class: LoansModule::AmortizationConfigs::InterestAmortization do
    
    calculation_type { 1 }
    factory :straight_line_interest_amortization, class: LoansModule::AmortizationConfigs::InterestAmortization do 
      calculation_type { "straight_line" }
    end 
  end
end
