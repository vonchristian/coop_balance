FactoryBot.define do
  factory :barangay, class: "Addresses::Barangay" do
    sequence(:name) { |n| "Barangay Name" +  ('a'..'z').to_a.shuffle.join }
    municipality { nil }
  end
end
