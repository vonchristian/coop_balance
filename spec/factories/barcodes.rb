FactoryBot.define do
  factory :barcode do
    code { "MyString" }
    barcodeable { nil }
  end
end
