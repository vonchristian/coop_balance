FactoryBot.define do
  factory :member, aliases: [:borrower] do
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    association :office
    sex 'male'
    date_of_birth { Faker::Date.birthday(18, 65) }
    avatar File.open(Rails.root.join('app', 'assets', 'images', 'default.png'))
  end
end
