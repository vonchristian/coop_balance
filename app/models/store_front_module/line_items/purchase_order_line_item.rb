module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItem < LineItem
      belongs_to :purchase_order, class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'order_id'
      has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'referenced_line_item_id'
      def out_of_stock?
        available_quantity.zero?
      end
      def sold_quantity
        sales_order_line_items.total
      end
      def available_quantity
        converted_quantity - sold_quantity
      end
    end
  end
end
