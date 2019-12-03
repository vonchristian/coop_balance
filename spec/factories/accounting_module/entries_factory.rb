FactoryBot.define do
  factory :entry, class: AccountingModule::Entry do
    association :recorder, factory: :user
    association :office
    association :cooperative
    description { Faker::Company.bs }
  end
end
