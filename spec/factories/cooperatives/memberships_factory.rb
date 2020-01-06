FactoryBot.define do
  factory :membership, class: Cooperatives::Membership do
    association :cooperator, factory: :member
    association :cooperative
    association :office
    association :membership_category
    account_number { SecureRandom.uuid }
  end
end
