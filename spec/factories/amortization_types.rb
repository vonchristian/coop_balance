FactoryBot.define do
  factory :amortization_type, class: LoansModule::AmortizationType do
    name { "MyString" }
    description { "MyString" }
    calculation_type { 1 }
  end
end
