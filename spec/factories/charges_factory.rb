FactoryBot.define do
  factory :charge do
    name "MyString"
    credit_account nil
    debit_account nil
    charge_type 1
    amount "9.99"
    percent "9.99"
  end
end