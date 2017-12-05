FactoryBot.define do
  factory :product, class: "StoreModule::Product" do
    sequence(:name) { |n| "Product " +  ('a'..'z').to_a.shuffle.join }
    description "MyString"
    unit "MyString"
  end
end
