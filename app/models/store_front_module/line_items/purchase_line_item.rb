module StoreFrontModule
  module LineItems
    class PurchaseLineItem < LineItem
      belongs_to :purchase_order,         class_name: "StoreFrontModule::Orders::PurchaseOrder",
                                          foreign_key: 'order_id'
      has_many :sales_purchase_line_items, class_name: "SalesPurchaseLineItem", foreign_key: 'purchase_line_item'
      has_many :purchase_returns,         class_name: "StoreFrontModule::LineItems::PurchaseReturnLineItem",
                                          foreign_key: 'purchase_line_item_id'
      has_many :internal_uses,            class_name: "StoreFrontModule::LineItems::InternalUseLineItem",
                                          foreign_key: 'purchase_line_item_id'
      has_many :sales_returns,            class_name: "StoreFrontModule::LineItems::SalesReturnLineItem",
                                          foreign_key: 'purchase_line_item_id'
      has_many :spoilages,                class_name: "StoreFrontModule::LineItems::SpoilageLineItem",
                                          foreign_key: 'purchase_line_item_id'
    
      delegate :supplier_name, to: :purchase_order, allow_nil: true

      def sold?
        sales_purchase_line_items.present? &&
        out_of_stock?
      end

      def self.available(args={})
        select { |a| a.available_quantity(args) > 0 }
      end

      def out_of_stock?
        sales_purchase_line_items.any? &&
        available_quantity.zero?
      end

      def available_quantity(args={})
        converted_quantity +
        sales_returns_quantity(args) +
        sold_quantity(args) -
        purchase_returns_quantity(args) -
        internal_uses_quantity(args) -
        spoilages_quantity(args)
      end
      def sold_quantity(args={})
        sales_purchase_line_items.total_quantity
      end

      def purchase_returns_quantity(args={})
        purchase_returns.processed.total_converted_quantity
      end
      def internal_uses_quantity(args={})
        internal_uses.processed.total_converted_quantity
      end

      def spoilages_quantity(args={})
        spoilages.processed.total_converted_quantity
      end

      def sales_returns_quantity(args={})
        sales_returns.processed.total_converted_quantity
      end



      def purchase_cost
        if unit_of_measurement.base_measurement?
          unit_cost
        else
          unit_cost / conversion_multiplier
        end
      end
    end
  end
end
