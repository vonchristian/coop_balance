# purchase order line item
# 40 pc
# 40 pc
# sales order line item
# 4 dozen = 48 dozen
module StoreFrontModule
  module LineItems
    class ReferencedPurchaseOrderLineItem < LineItem
      belongs_to :sales_order_line_item
      belongs_to :purchase_order_line_item
      delegate :purchase_cost, to: :purchase_order_line_item

      def self.cost_of_goods_sold
        sum(&:cost_of_goods_sold)
      end

      def cost_of_goods_sold
        unit_cost * quantity
      end
    end
  end
end
