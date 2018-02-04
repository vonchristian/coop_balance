module StoreFrontModule
  module Orders
    class SalesOrder < Order

      has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem",
                                 extend: StoreFrontModule::QuantityBalanceFinder, foreign_key: 'order_id'
    end
  end
end
