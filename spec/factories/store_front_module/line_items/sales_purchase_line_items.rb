FactoryBot.define do
  factory :sales_purchase_line_item, class: StoreFrontModule::LineItems::SalesPurchaseLineItem do
    sales_line_item { nil }
    purchase_line_item { nil }
  end
end
