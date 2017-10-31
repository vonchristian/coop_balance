FactoryBot.define do
  factory :membership do
    memberable nil
    membership_date "2017-08-22 20:55:11"
    cooperative nil

    factory :regular_membership do
      membership_type 'regular_member'
    end

    factory :associate_membership do
      membership_type 'associate_member'
    end
  end
end
