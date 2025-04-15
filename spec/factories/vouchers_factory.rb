FactoryBot.define do
  factory :voucher, class: TreasuryModule::Voucher do
    office
    cooperative
    commercial_document factory: %i[member]
    payee factory: %i[member]
    preparer factory: %i[teller]
    disburser factory: %i[teller]
    account_number { SecureRandom.uuid }
    description { Faker::Company.bs }
    reference_number { SecureRandom.uuid }
  end
end
