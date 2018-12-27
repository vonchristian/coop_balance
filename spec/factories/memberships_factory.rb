FactoryBot.define do
  factory :membership do
    membership_date { "2017-08-22 20:55:11" }
    cooperative
    account_number { SecureRandom.uuid }

    factory :regular_membership do
      membership_type { 'regular_member' }
    end

    factory :associate_membership do
      membership_type { 'associate_member' }
    end
  end
end
