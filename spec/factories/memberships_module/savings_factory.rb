FactoryBot.define do
  factory :saving, class: "MembershipsModule::Saving" do
    association :depositor, factory: :member
    association :saving_product
    association :cooperative
    account_number { SecureRandom.uuid }
  end
end
