FactoryBot.define do
  factory :wallet do
    account_owner  { nil }
    account        { nil }
    account_number { "MyString" }
  end
end
