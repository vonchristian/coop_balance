FactoryBot.define do
  factory :sales_line_item, class: "StoreFrontModule::LineItems::SalesLineItem" do
    association :product
    association :unit_of_measurement
    
    quantity   { 1 }
    unit_cost  { 100 }
    total_cost { 100 }
  end
end
