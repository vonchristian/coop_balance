FactoryBot.define do
  factory :voucher do
    number { SecureRandom.uuid }
    association :preparer, factory: :user
    association :disburser, factory: :user
    account_number { SecureRandom.uuid }
    factory :disbursed_voucher do |voucher_cd|
      voucher_cd.after(:build) do |t|
        create(:entry_with_credit_and_debit, :commercial_document => t)
      end
    end
  end
end
