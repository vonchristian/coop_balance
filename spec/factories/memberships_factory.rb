FactoryBot.define do
  factory :membership, class: "Cooperatives::Membership" do
    membership_date { "2017-08-22 20:55:11" }
    association :cooperative
    association :cooperator, factory: :member
    account_number { SecureRandom.uuid }

    factory :regular_membership do
      membership_type { 'regular_member' }
      association :cooperative
    end

    factory :associate_membership do
      membership_type { 'associate_member' }
    end
  end
end
