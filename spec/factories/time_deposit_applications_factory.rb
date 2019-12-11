FactoryBot.define do
  factory :time_deposit_application do
    association :time_deposit_product
    association :liability_account, factory: :liability
    association :cooperative
    association :depositor, factory: :member
    account_number { SecureRandom.uuid }
    date_deposited { Date.current }
    term { 90 }
  end
end
