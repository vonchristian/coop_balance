FactoryBot.define do
  factory :product_stock, class: "StoreModule::ProductStock" do
    unit_cost "9.99"
    total_cost "9.99"
    product
    supplier
    date "2017-06-12 11:43:33"
    quantity 1
    barcode '11111111'
    name ''
    retail_price 100
    wholesale_price 100
  end
end
