FactoryBot.define do
  factory :time_deposit, class: "MembershipsModule::TimeDeposit" do
    association :depositor, factory: :member
    association :time_deposit_product
    account_number nil
    number_of_days 90
  end
end
