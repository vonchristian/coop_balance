FactoryBot.define do
  factory :office, class: 'Cooperatives::Office' do
    cooperative
    name           { "#{Faker::Company.bs}-#{SecureRandom.uuid}" }
    type           { 'Cooperatives::Offices::SatelliteOffice' }
    contact_number { 313_123 }
    address        { Faker::Address.full_address }
  end
end
