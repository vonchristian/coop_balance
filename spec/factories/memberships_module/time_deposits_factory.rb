FactoryBot.define do
  factory :time_deposit, class: "MembershipsModule::TimeDeposit" do
    association :depositor, factory: :member
    association :time_deposit_product
    account_number { nil }
  end
end
