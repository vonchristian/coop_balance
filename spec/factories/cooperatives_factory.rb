FactoryBot.define do
  factory :cooperative do
    sequence(:name) { |n| "Cooperative " +  ('a'..'z').to_a.shuffle.join }
    sequence(:abbreviated_name) { |n| "abbreviated_name " +  ('a'..'z').to_a.shuffle.join }

    sequence(:registration_number) { |n| "Reg num" +  ('a'..'z').to_a.shuffle.join }
  end
end
