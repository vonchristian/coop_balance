module StoreFrontModule
  module LineItems
    class PurchaseLineItem < LineItem
      belongs_to :purchase_order,                 class_name: "StoreFrontModule::Orders::PurchaseOrder",
                                                  foreign_key: 'order_id'
      has_many :referenced_purchase_line_items,   class_name: "StoreFrontModule::LineItems::ReferencedPurchaseLineItem",
                                                  foreign_key: 'purchase_line_item_id'
      has_many :purchase_return_line_items,       class_name: "StoreFrontModule::LineItems::PurchaseReturnLineItem",
                                                  foreign_key: 'purchase_line_item_id'
      has_many :internal_use_line_items,          class_name: "StoreFrontModule::LineItems::InternalUseLineItem",
                                                  foreign_key: 'purchase_line_item_id'
      has_many :stock_transfer_line_items,        class_name: "StoreFrontModule::LineItems::StockTransferLineItem",
                                                  foreign_key: 'purchase_line_item_id'
      has_many :returned_sales_line_items,        class_name: "StoreFrontModule::LineItems::ReferencedSalesLineItem",
                                                  foreign_key: 'purchase_line_item_id'
      has_many :spoilage_line_items,              class_name: "StoreFrontModule::LineItems::SpoilageLineItem",
                                                  foreign_key: 'purchase_line_item_id'
      has_many :received_stock_transfer_line_items, class_name: "StoreFrontModule::LineItems::ReceivedStockTransferLineItem",
                                                  foreign_key: 'purchase_line_item_id'

      validates :expiry_date, presence: true
      delegate :supplier_name, :date, to: :purchase_order, allow_nil: true



      def sold?
        referenced_purchase_order_line_items.present? &&
        out_of_stock?
      end

      def self.available
        select { |a| !a.out_of_stock? }
      end

      def out_of_stock?
        referenced_purchase_line_items.any? &&
        available_quantity.zero?
      end

      def available_quantity
        returned_sales_quantity +
        received_stock_transfer_quantity +
        converted_quantity -
        sold_quantity -
        purchase_returns_quantity -
        internal_uses_quantity -
        stock_transfers_quantity -
        spoilage_quantity
      end

      def sold_quantity
        referenced_purchase_line_items.processed.sum(&:converted_quantity)
      end

      def purchase_returns_quantity
        purchase_return_line_items.processed.sum(&:converted_quantity)
      end
      def internal_uses_quantity
        internal_use_line_items.processed.sum(&:converted_quantity)
      end
      def stock_transfers_quantity
        stock_transfer_line_items.processed.sum(&:converted_quantity)
      end
      def spoilage_quantity
        spoilage_line_items.processed.sum(&:converted_quantity)
      end

      def returned_sales_quantity
        purchase_return_line_items.sum(&:converted_quantity)
      end
      def received_stock_transfer_quantity
        received_stock_transfer_line_items.sum(&:converted_quantity)
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
