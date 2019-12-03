FactoryBot.define do
  factory :share_capital_application do
    association :equity_account, factory: :equity
    association :office
    association :cooperative
    association :subscriber, factory: :member
    association :share_capital_product
    account_number { SecureRandom.uuid }
  end
end
