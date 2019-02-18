FactoryBot.define do
  factory :voucher_amount, class: "Vouchers::VoucherAmount" do
    amount      { Faker::Number.number(12) }
    association :account, factory: :asset
  end
end
