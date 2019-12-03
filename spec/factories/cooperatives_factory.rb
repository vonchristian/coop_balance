FactoryBot.define do
  factory :cooperative do
    name                { Faker::Name.name }
    address             { Faker::Address.full_address }
    abbreviated_name    { Faker::Name.name }
    registration_number { Faker::Number.number(12) }
    after(:build) do |coop|
    coop.logo.attach(io: File.open(Rails.root.join('spec', 'support', 'images', 'default.png')), filename: 'default.png', content_type: 'image/png')
  end
  end
end
