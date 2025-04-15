FactoryBot.define do
  factory :voucher_amount, class: 'Vouchers::VoucherAmount' do
    amount { Faker::Number.number(digits: 12) }
    account factory: %i[asset]

    factory :credit_voucher_amount, class: 'Vouchers::VoucherAmount' do
      amount_type { 'credit' }
    end

    factory :debit_voucher_amount, class: 'Vouchers::VoucherAmount' do
      amount_type { 'debit' }
    end
  end
end
