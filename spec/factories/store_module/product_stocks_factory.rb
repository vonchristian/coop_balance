FactoryBot.define do
  factory :product_stock, class: "StoreFrontModule::ProductStock" do
    unit_cost "9.99"
    total_cost "9.99"
    product
    supplier
    quantity 1
    barcode '11111111'
    sequence(:name) { |n| "ProductStock " +  ('a'..'z').to_a.shuffle.join }
    retail_price 100
    wholesale_price 100
  end
end
