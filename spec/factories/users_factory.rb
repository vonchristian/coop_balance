FactoryBot.define do
  factory :user, aliases: [:employee] do
    email                 { Faker::Internet.email }
    password              { '12345678' }
    password_confirmation { '12345678' }
    after(:build) do |u|
      cooperative = create(:cooperative)
      office      = create(:office, cooperative: cooperative)
      u.office = office
      u.cooperative = cooperative
    end

    factory :loan_officer, class: User do
      role { 'loan_officer' }
    end

    factory :teller, class: User do
      role { 'teller' }
    end

    factory :general_manager, class: User do
      role { 'general_manager' }
    end

    factory :bookkeeper, class: User do
      role { 'bookkeeper' }
    end

    factory :accountant, class: User do
      role { 'accountant' }
    end
  end
end
