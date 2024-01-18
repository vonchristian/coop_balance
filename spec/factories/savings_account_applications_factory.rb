FactoryBot.define do
  factory :savings_account_application do
    depositor factory: %i[member]
    cooperative
    office
    saving_product
    liability_account factory: %i[liability]
    account_number { SecureRandom.uuid }
  end
end
