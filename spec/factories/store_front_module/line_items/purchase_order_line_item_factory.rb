FactoryBot.define do
  factory :purchase_order_line_item, class: "StoreFrontModule::LineItems::PurchaseOrderLineItem" do
    association :product
    association :unit_of_measurement
  end
end

