FactoryBot.define do
  factory :voucher_amount, class: "Vouchers::VoucherAmount" do
    amount      { Faker::Number.number(12) }
    association :account, factory: :asset
    
    factory :credit_voucher_amount, class: 'Vouchers::VoucherAmount' do 
      amount_type {'credit' }
    end

    factory :debit_voucher_amount, class: 'Vouchers::VoucherAmount' do 
      amount_type { 'debit' }
    end
  end
end
