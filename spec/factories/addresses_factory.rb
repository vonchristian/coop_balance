FactoryBot.define do
  factory :address do
    street
    barangay
    municipality
    province
    addressable { nil }
    current { false }
  end
end
