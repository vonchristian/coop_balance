FactoryBot.define do
  factory :voucher_amount, class: Vouchers::VoucherAmount do
    amount { "9.99" }
    association :account, factory: :asset
    association :commercial_document, factory: :saving
  end
end
