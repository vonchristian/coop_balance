module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItem < LineItem
      belongs_to :purchase_order, class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'order_id'
      has_many :sales_order_line_items, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem", foreign_key: 'referenced_line_item_id'
      delegate :supplier_name, :date, to: :purchase_order
      def self.processed
        select{|a| a.processed? }
      end
      def processed?
        purchase_order && purchase_order.processed?
      end

      def self.available
        select { |a| !a.out_of_stock? }
      end
      def out_of_stock?
        available_quantity.zero?
      end
      def sold_quantity
        sales_order_line_items.total
      end
      def available_quantity
        converted_quantity -
        sold_quantity
      end

      def purchase_cost
        if unit_of_measurement.base_measurement?
          unit_cost
        else
          unit_cost / unit_of_measurement.conversion_multiplier
        end
      end
    end
  end
end
