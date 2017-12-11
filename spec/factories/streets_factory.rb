FactoryBot.define do
  factory :street, class: "Addresses::Street" do
    barangay nil
    municipality nil
    sequence(:name) { |n| "Street Name" +  ('a'..'z').to_a.shuffle.join }
  end
end
