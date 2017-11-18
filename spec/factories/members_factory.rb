FactoryBot.define do
  factory :member, aliases: [:borrower] do
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    association :branch_office
    sex 'male'
    date_of_birth { Faker::Date.birthday(18, 65) }
    factory :regular_member do
      association :membership, factory: :regular_membership
    end
    factory :associate_member do
      association :membership, factory: :associate_membership
    end
  end
end
