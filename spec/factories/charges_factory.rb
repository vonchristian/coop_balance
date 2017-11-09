FactoryBot.define do
  factory :charge do
    name "MyString"
    association :account, factory: :revenue
    charge_type 1
    amount "9.99"
    percent "9.99"
  end
end
