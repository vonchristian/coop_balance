FactoryBot.define do
  factory :line_item, class: "StoreFrontModule::LineItem" do
    association :product
    association :unit_of_measurement
    unit_cost "9.99"
    total_cost "9.99"
    date "2017-06-12 13:15:14"
    expiry_date Date.today.next_year

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
      association :sales_order
    end
    factory :sales_return_line_item_with_base_measurement, class: "StoreFrontModule::LineItems::SalesReturnLineItem" do
      association :unit_of_measurement, factory: :base_measurement
      association :sales_return_order
    end
    factory :internal_use_line_item_with_base_measurement, class: "StoreFrontModule::LineItems::InternalUseLineItem" do
      association :unit_of_measurement, factory: :base_measurement
      association :internal_use_order
      association :purchase_line_item
    end
    factory :stock_transfer_line_item_with_base_measurement, class: "StoreFrontModule::LineItems::StockTransferLineItem" do
      association :unit_of_measurement, factory: :base_measurement
      association :stock_transfer_order
    end
    factory :received_stock_transfer_line_item_with_base_measurement, class: "StoreFrontModule::LineItems::ReceivedStockTransferLineItem" do
      association :unit_of_measurement, factory: :base_measurement
      association :received_stock_transfer_order
    end
    factory :spoilage_line_item_with_base_measurement, class: "StoreFrontModule::LineItems::SpoilageLineItem" do
      association :unit_of_measurement, factory: :base_measurement
      association :spoilage_order
    end
    factory :referenced_purchase_line_item_with_base_measurement, class: "StoreFrontModule::LineItems::ReferencedPurchaseLineItem" do
      association :unit_of_measurement, factory: :base_measurement
    end
  end
end
