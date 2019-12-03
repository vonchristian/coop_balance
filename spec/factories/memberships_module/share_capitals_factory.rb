FactoryBot.define do
  factory :share_capital, class: MembershipsModule::ShareCapital do
    association :office
    association :subscriber, factory: :member
    association :share_capital_equity_account, factory: :equity
    association :interest_on_capital_account, factory: :equity
    association :share_capital_product
    account_number { SecureRandom.uuid }
  end
end
