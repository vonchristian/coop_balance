FactoryBot.define do
  factory :origin_cooperative, class: Cooperative do
    name "Test Cooperative"
    abbreviated_name "TC"
    registration_number { "000-1110222" }
  end
  factory :cooperative do
    sequence(:name) { |n| "Cooperative " +  ('a'..'z').to_a.shuffle.join }
    sequence(:abbreviated_name) { |n| "abbreviated_name " +  ('a'..'z').to_a.shuffle.join }

    sequence(:registration_number) { |n| "Reg num" +  ('a'..'z').to_a.shuffle.join }
  end
end
