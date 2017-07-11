FactoryGirl.define do
  factory :product_stock, class: "StoreModule::ProductStock" do
    unit_cost "9.99"
    total_cost "9.99"
    product nil
    supplier
    date "2017-06-12 11:43:33"
  end
end
