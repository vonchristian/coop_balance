FactoryBot.define do 
  factory :bank_account do 
    association :office 
    association :cash_account, factory: :asset 
    association :interest_revenue_account, factory: :revenue 
    bank_name { Faker::Company.name }
    bank_address { Faker::Address.full_address }
    account_number { SecureRandom.uuid }
  end 
end 