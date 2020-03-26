FactoryBot.define do
  factory :utility_bill do
    amount { "9.99" }
    merchant { nil }
    utility_bill_category { nil }
    voucher { nil }
    description { "MyString" }
    reference_number { "MyString" }
  end
end
