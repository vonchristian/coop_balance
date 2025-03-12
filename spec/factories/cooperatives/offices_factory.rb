FactoryBot.define do
  factory :office, class: 'Cooperatives::Office' do
    cooperative
    name           { "#{Faker::Company.bs}-#{SecureRandom.uuid}" }
    office_type    { 'main_office' }
    contact_number { 313_123 }
    address        { Faker::Address.full_address }
  end
end
