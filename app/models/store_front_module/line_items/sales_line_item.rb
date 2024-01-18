module StoreFrontModule
  module LineItems
    class SalesLineItem < LineItem
      belongs_to :sales_order, class_name: 'StoreFrontModule::Orders::SalesOrder', foreign_key: 'order_id'
      has_many :sales_purchase_line_items
      delegate :customer, :date, :customer_name, to: :sales_order, allow_nil: true

      def self.cost_of_goods_sold
        sum(&:cost_of_goods_sold)
      end

      delegate :cost_of_goods_sold, to: :sales_purchase_line_items
    end
  end
end
