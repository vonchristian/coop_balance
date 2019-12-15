FactoryBot.define do
  factory :time_deposit_application do
    association :time_deposit_product
    association :liability_account, factory: :liability
    association :cooperative
    association :office 
    association :depositor, factory: :member
    account_number { SecureRandom.uuid }
    date_deposited { Date.current }
    number_of_days { 90 }
  end
end
