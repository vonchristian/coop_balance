FactoryBot.define do
  factory :account_category, class: AccountingModule::AccountCategory do
    title { "MyString" }
    association :cooperative
    code { SecureRandom.uuid }
  end
end
