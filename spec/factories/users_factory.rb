FactoryBot.define do
  factory :user do
    association :office
    association :cooperative
    email                 { Faker::Internet.email }
    password              { '12345678' }
    password_confirmation { '12345678' }

    factory :loan_officer, class: User do
      role { 'loan_officer' }
    end

    factory :teller, class: User do
      role { 'teller' }
    end

    factory :accountant, class: User do
      role { 'accountant' }
    end
  end
end
