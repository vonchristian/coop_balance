FactoryBot.define do
  factory :product, class: "StoreModule::Product" do
    name { Faker::Ecommerce.name }
    description "MyString"
    unit "MyString"
  end
end
