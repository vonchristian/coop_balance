FactoryBot.define do
  factory :referenced_purchase_line_item, class: "StoreFrontModule::LineItems::ReferencedPurchaseLineItem" do
    association :purchase_line_item
    association :sales_line_item
    association :unit_of_measurement
    association :product
  end
end
