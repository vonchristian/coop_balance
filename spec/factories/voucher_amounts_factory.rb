FactoryBot.define do
  factory :voucher_amount, class: Vouchers::VoucherAmount do
    amount "9.99"
    association :account, factory: :asset
    voucher nil
  end
end
