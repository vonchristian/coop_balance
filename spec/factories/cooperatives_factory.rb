FactoryBot.define do
  factory :cooperative do
    name                { Faker::Company.bs }
    address             { Faker::Address.full_address }
    abbreviated_name    { Faker::Name.name }
    registration_number { Faker::Number.number(digits: 12) }
    after(:build) do |coop|
      coop.logo.attach(io: Rails.root.join('spec/support/images/default.png').open, filename: 'default.png', content_type: 'image/png')
    end
  end
end
