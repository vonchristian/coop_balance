FactoryBot.define do
  factory :contact do
    contactable factory: %i[member]
  end
end
