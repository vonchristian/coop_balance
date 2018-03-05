FactoryBot.define do
  factory :line_item, class: "StoreFrontModule::LineItem" do
    association :commercial_document, factory: :supplier
    association :product
    association :unit_of_measurement
    unit_cost "9.99"
    total_cost "9.99"
    date "2017-06-12 13:15:14"

    factory :purchase_line_item_with_base_measurement do
      type "StoreFrontModule::PurchaseLineItem"
      association :unit_of_measurement, factory: :base_measurement
    end

    factory :purchase_line_item_with_conversion_multiplier do
      type "StoreFrontModule::PurchaseLineItem"
      association :unit_of_measurement, factory: :measurement_with_conversion_multiplier
    end

    factory :purchase_return_line_item_with_base_measurement do
      type "StoreFrontModule::PurchaseReturnLineItem"
      association :unit_of_measurement, factory: :base_measurement
    end

    factory :purchase_return_line_item_with_conversion_multiplier do
      type "StoreFrontModule::PurchaseReturnLineItem"
      association :unit_of_measurement, factory: :measurement_with_conversion_multiplier
    end

    factory :sales_line_item_with_base_measurement do
      type "StoreFrontModule::SalesLineItem"
      association :unit_of_measurement, factory: :base_measurement
    end
  end
end