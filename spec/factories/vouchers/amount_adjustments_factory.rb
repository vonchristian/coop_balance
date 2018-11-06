FactoryBot.define do
  factory :amount_adjustment, class: Vouchers::AmountAdjustment do
    rate { 0.1 }
    amount  { 100 }
    number_of_payments { 3 }
    association :loan_application
  end
end
