FactoryBot.define do
  factory :product, class: "StoreFrontModule::Product" do
    sequence(:name) { |n| "Product " +  ('a'..'z').to_a.shuffle.join }
    description "MyString"

  end
end
