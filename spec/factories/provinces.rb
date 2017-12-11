FactoryBot.define do
  factory :province, class: "Addresses::Province" do
    sequence(:name) { |n| "Province Name" +  ('a'..'z').to_a.shuffle.join }
  end
end
