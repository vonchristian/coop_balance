FactoryBot.define do
  factory :office, class: Cooperatives::Office do
    association :cooperative
    name           { "#{Faker::Company.bs}-#{SecureRandom.uuid}" }
    type           { "Cooperatives::Offices::SatelliteOffice" }
    contact_number { 313123 }
    address        { Faker::Address.full_address }
  end
end
