module StoreFrontModule
  module LineItems
    class ReferencedPurchaseLineItem < LineItem
      belongs_to :sales_line_item
      belongs_to :purchase_line_item
      delegate :purchase_cost, to: :purchase_line_item

      def self.cost_of_goods_sold
        sum(&:cost_of_goods_sold)
      end

      def cost_of_goods_sold
        unit_cost * quantity
      end
    end
  end
end
