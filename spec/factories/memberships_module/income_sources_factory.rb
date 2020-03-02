FactoryBot.define do
  factory :income_source, class: MembershipsModule::IncomeSource do
    designation { "MyString" }
    description { "MyString" }
    monthly_income { "9.99" }
    income_source_category { nil }
    member { nil }
  end
end
