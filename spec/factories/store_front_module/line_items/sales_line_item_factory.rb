FactoryBot.define do
  factory :sales_line_item, class: "StoreFrontModule::LineItems::SalesLineItem" do
    association :product
    association :unit_of_measurement
    association :sales_order
  end
end
