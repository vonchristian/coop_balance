FactoryGirl.define do
  factory :saving, class: "MembershipsModule::Saving" do
    association :account_owner, factory: :member
    account_number "MyString"
  end
end
