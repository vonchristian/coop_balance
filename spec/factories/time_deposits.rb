FactoryGirl.define do
  factory :time_deposit, class: "MembershipsModule::TimeDeposit" do
    association :depositor, factory: :member
    time_deposit_product nil
    account_number "MyString"
  end
end
