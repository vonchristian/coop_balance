FactoryBot.define do
  factory :amortization_type, class: LoansModule::AmortizationType do
    name { "MyString" }
    description { "MyString" }
    calculation_type { 1 }
    factory :straight_line_amortization_type, class: "LoansModule::AmortizationType" do
      calculation_type { "straight_line" }
    end
  end
end
