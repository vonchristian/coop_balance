FactoryGirl.define do
  factory :share_capital, class: "MembershipsModule::ShareCapital" do
    association :account_owner, factory: :member
    account_number  { Faker::Number.number(11) }
    date_opened "2017-06-07 14:17:32"
  end
end
