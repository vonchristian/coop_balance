FactoryBot.define do
  factory :amortization_type, class: LoansModule::AmortizationType do
    name { "MyString" }
    description { "MyString" }
    calculation_type { 1 }
    repayment_calculation_type { 1}
    factory :straight_line_amortization_type, class: "LoansModule::AmortizationType" do
      calculation_type { "straight_line" }
    end

    factory :declining_balance_amortization_type, class: "LoansModule::AmortizationType" do
      calculation_type { "declining_balance" }
    end

    factory :equal_payment_amortization_type, class: "LoansModule::AmortizationType" do
      repayment_calculation_type { "equal_payment" }
    end

    factory :equal_principal_amortization_type, class: "LoansModule::AmortizationType" do
      repayment_calculation_type { "equal_principal" }
    end
  end
end
