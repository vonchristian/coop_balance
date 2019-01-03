module StoreFrontModule
  module LineItems
    class SalesPurchaseLineItem < LineItem
      belongs_to :sales_line_item, class_name: "StoreFrontModule::LineItems::SalesLineItem", foreign_key: 'sales_line_item_id'
      belongs_to :purchase_line_item, class_name: "StoreFrontModule::LineItems::PurchaseLineItem", foreign_key: 'purchase_line_item_id'
      delegate :sales_order, to: :sales_line_item

      def self.total_quantity
        sum(:quantity)
      end
      def self.cost_of_goods_sold
        sum(&:cost_of_goods_sold)
      end
      def cost_of_goods_sold
        quantity * unit_cost
      end
    end
  end
end
