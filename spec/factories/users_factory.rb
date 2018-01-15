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
    association :cash_on_hand_account, factory: :asset
    factory :loan_officer do
      role 'loan_officer'
    end
    factory :manager do
      role 'manager'
    end
    factory :sales_clerk do
      role 'sales_clerk'
    end
    factory :treasurer do
      role 'treasurer'
    end
  end
end
