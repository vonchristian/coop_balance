FactoryBot.define do
  factory :voucher do
    association :office
    association :cooperative
    association :commercial_document, factory: :member
    association :payee, factory: :member
    association :preparer, factory: :teller
    association :disburser, factory: :teller
    account_number { SecureRandom.uuid }
    description { Faker::Company.bs }
    reference_number { SecureRandom.uuid }
  end
end
