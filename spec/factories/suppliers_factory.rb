FactoryBot.define do
  factory :supplier do
    sequence(:business_name) { |n| "Supplier " +  ('a'..'z').to_a.shuffle.join }
    first_name "MyString"
    last_name "MyString"
    contact_number "MyString"
  end
end
