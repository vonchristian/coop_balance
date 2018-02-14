module StoreFrontModule
  module LineItems
    class SalesOrderLineItem < LineItem
      belongs_to :purchase_order_line_item, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'referenced_line_item_id'
      belongs_to :sales_order, class_name: "StoreFrontModule::Orders::SalesOrder", foreign_key: 'order_id'
      delegate :customer, :official_receipt_number, :date, :customer_name, to: :sales_order, allow_nil: true

      def cost_of_goods_sold
        referenced_line_item.purchase_cost * quantity
      end
    end
  end
end
