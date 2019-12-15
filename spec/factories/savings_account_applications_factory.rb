FactoryBot.define do
  factory :savings_account_application do
    association :depositor, factory: :member
    association :cooperative
    association :office
    association :saving_product
    association :liability_account, factory: :liability
    account_number { SecureRandom.uuid }
  end
end
