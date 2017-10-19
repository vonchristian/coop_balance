FactoryGirl.define do
  factory :saving, class: "MembershipsModule::Saving" do
    association :depositor, factory: :member
    account_number "MyString"
  end
end
