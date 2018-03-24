module StoreFrontModule
  module LineItems
    class ReferencedPurchaseLineItem < LineItem
      belongs_to :purchase_line_item, class_name: "StoreFrontModule::LineItems::PurchaseLineItem",
                                      foreign_key: 'purchase_line_item_id'
      belongs_to :sales_line_item, class_name: "StoreFrontModule::LineItems::SalesLineItem",
                                    foreign_key: 'sales_line_item_id'

      delegate :purchase_cost, to: :purchase_line_item
      delegate :sales_order, to: :sales_line_item
      delegate :customer, to: :sales_order
      delegate :name, to: :customer, prefix: true
      def self.cost_of_goods_sold
        sum(&:cost_of_goods_sold)
      end

      def cost_of_goods_sold
        unit_cost * quantity
      end

    end
  end
end
