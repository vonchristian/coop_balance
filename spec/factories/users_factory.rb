FactoryBot.define do
  factory :user, aliases: [:employee] do
    first_name  { Faker::Name.unique.first_name }
    middle_name { Faker::Name.last_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.email }
    password    'secretpassword'
    password_confirmation 'secretpassword'
    role 0
    cooperative
    factory :loan_officer do
      role 'loan_officer'
    end
  end
end
