FactoryBot.define do
  factory :membership, class: Cooperatives::Membership do
    association :cooperator, factory: :member
    association :cooperative
    account_number { SecureRandom.uuid }
  end
end
