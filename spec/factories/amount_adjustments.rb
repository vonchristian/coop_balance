FactoryBot.define do
  factory :amount_adjustment do
    voucher_amount { nil }
    amount { "9.99" }
    percent { "9.99" }
    number_of_payments { 1 }
  end
end
