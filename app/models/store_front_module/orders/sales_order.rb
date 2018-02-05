module StoreFrontModule
  module Orders
    class SalesOrder < Order
      has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem",
                                 extend: StoreFrontModule::QuantityBalanceFinder, foreign_key: 'order_id'
      has_many :products, through: :sales_order_line_items, class_name: "StoreFrontModule::Product"

      def customer_name
        commercial_document_name
      end
      def customer
        commercial_document
      end

      def line_items_quantity(product)
        sales_order_line_items.where(product: product).sum(&:quantity)
      end

      def line_items_total_cost(product)
        sales_order_line_items.where(product: product).sum(&:total_cost)
      end
    end
  end
end
