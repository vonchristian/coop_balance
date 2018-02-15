module StoreFrontModule
  module LineItems
    class SalesOrderLineItem < LineItem

      belongs_to :sales_order, class_name: "StoreFrontModule::Orders::SalesOrder", foreign_key: 'order_id'
      has_many :referenced_purchase_order_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseOrderLineItem", foreign_key: 'sales_order_line_item_id', dependent: :destroy
      delegate :customer, :official_receipt_number, :date, :customer_name, to: :sales_order, allow_nil: true

      def cost_of_goods_sold
        referenced_purchase_order_line_items.map{|a| a.purchase_cost * a.quantity }.sum
      end

      def quantity_for(purchase_order_line_item)
        purchase_order_line_items.where(purchase_order_line_item: purchase_order_line_item).sum(&:quantity)
      end
    end
  end
end
