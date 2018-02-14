FactoryBot.define do
  factory :municipality, class: "Addresses::Municipality" do
    sequence(:name) { |n| "Street Name" +  ('a'..'z').to_a.shuffle.join }
  end
end
