FactoryBot.define do
  factory :street, class: 'Addresses::Street' do
    name { Faker::Address.street_name }
    barangay
    municipality
  end
end
