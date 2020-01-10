FactoryBot.define do
  factory :share_capital, class: MembershipsModule::ShareCapital do
    association :office
    association :cooperative
    association :subscriber, factory: :member
    association :share_capital_equity_account, factory: :equity
    association :share_capital_product
    account_number        { SecureRandom.uuid }
    last_transaction_date { Date.current }
  end
end
