FactoryBot.define do
  factory :saving, class: "MembershipsModule::Saving" do
    association :depositor, factory: :member
    association :saving_product
    association :section
    account_number "MyString"
  end
end
