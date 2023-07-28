FactoryBot.define do
  factory :ledger do
    account_type { "MyString" }
    code { "MyString" }
    name { "MyString" }
    contra { false }
  end
end
