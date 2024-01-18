FactoryBot.define do
  factory :address do
    addressable factory: %i[member]
    street
    barangay
    municipality
    province
  end
end
