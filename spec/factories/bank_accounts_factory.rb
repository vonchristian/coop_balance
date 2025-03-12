FactoryBot.define do
  factory :bank_account do
    office
    cash_account factory: %i[asset]
    interest_revenue_account factory: %i[revenue]
    bank_name { Faker::Company.name }
    bank_address { Faker::Address.full_address }
    account_number { SecureRandom.uuid }
  end
end
