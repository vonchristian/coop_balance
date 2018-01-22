FactoryBot.define do
  factory :voucher do
    number "MyString"
    association :preparer, factory: :user
    association :disburser, factory: :user
  end
end
