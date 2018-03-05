FactoryBot.define do
  factory :saving, class: "MembershipsModule::Saving" do
    association :depositor, factory: :member
    association :saving_product
    account_number { SecureRandom.uuid }
  end
end
