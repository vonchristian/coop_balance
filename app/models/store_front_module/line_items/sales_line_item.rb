module StoreFrontModule
  module LineItems
    class SalesLineItem < LineItem
      belongs_to :sales_order,                  class_name: "StoreFrontModule::Orders::SalesOrder", foreign_key: 'order_id'
      has_many :referenced_purchase_line_items, class_name: "StoreFrontModule::LineItems::ReferencedPurchaseLineItem",
                                                foreign_key: 'sales_order_line_item_id',
                                                dependent: :destroy

      delegate :customer, :official_receipt_number, :date, :customer_name, to: :sales_order, allow_nil: true

      def self.cost_of_goods_sold
        sum(&:cost_of_goods_sold)
      end

      def cost_of_goods_sold
        referenced_purchase_order_line_items.cost_of_goods_sold
      end
    end
  end
end
