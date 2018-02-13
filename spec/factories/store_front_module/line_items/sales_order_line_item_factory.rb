FactoryBot.define do
  factory :sales_order_line_item, class: "StoreFrontModule::LineItems::SalesOrderLineItem" do
    association :product
    association :unit_of_measurement
  end
end
