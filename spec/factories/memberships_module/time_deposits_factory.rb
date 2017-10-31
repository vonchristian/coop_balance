FactoryBot.define do
  factory :time_deposit, class: "MembershipsModule::TimeDeposit" do
    association :depositor, factory: :member
    time_deposit_product
    account_number "MyString"
    number_of_days 90
  end
end
