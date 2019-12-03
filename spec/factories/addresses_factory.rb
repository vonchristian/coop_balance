FactoryBot.define do
  factory :address do
    association :addressable, factory: :member
    association :street
    association :barangay
    association :municipality
    association :province
  end
end
