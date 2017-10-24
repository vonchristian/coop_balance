FactoryBot.define do
  factory :share_capital, class: "MembershipsModule::ShareCapital" do
    association :subscriber, factory: :member
    share_capital_product
    account_number  { Faker::Number.number(11) }
    date_opened "2017-06-07 14:17:32"
  end
end
