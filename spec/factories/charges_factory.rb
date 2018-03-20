FactoryBot.define do
  factory :charge do
    sequence(:name) { |n| "Charge " +  ('a'..'z').to_a.shuffle.join }
    association :account, factory: :revenue
    charge_type 1
    amount 100
    percent "9.99"
    factory :interest_on_loan_charge do
      association :account, factory: :asset
    end
  end
end
