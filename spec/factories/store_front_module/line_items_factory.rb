FactoryBot.define do
  factory :line_item, class: "StoreFrontModule::LineItem" do
    association :product
    association :unit_of_measurement
    unit_cost "9.99"
    total_cost "9.99"
    date "2017-06-12 13:15:14"

    factory :purchase_line_item_with_base_measurement, class: "StoreFrontModule::LineItems::PurchaseLineItem" do
      association :unit_of_measurement, factory: :base_measurement
      association :purchase_order
    end

    factory :purchase_line_item_with_conversion_multiplier, class: "StoreFrontModule::LineItems::PurchaseLineItem" do
      association :unit_of_measurement, factory: :measurement_with_conversion_multiplier
      association :purchase_order
    end

    factory :purchase_return_line_item_with_base_measurement, class: "StoreFrontModule::LineItems::PurchaseReturnLineItem" do
      association :unit_of_measurement, factory: :base_measurement
      association :purchase_return_order

    end

    factory :purchase_return_line_item_with_conversion_multiplier, class: "StoreFrontModule::LineItems::PurchaseReturnLineItem" do
      association :unit_of_measurement, factory: :measurement_with_conversion_multiplier
      association :purchase_return_order
    end

    factory :sales_line_item_with_base_measurement, class: "StoreFrontModule::LineItems::SalesLineItem" do
      association :unit_of_measurement, factory: :base_measurement
    end
  end
end
