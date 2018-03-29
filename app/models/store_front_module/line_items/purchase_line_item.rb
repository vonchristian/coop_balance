module StoreFrontModule
  module LineItems
    class PurchaseLineItem < LineItem
      belongs_to :purchase_order,         class_name: "StoreFrontModule::Orders::PurchaseOrder",
                                          foreign_key: 'order_id'
      has_many :sales,                    class_name: "StoreFrontModule::LineItems::ReferencedPurchaseLineItem",
                                          foreign_key: 'purchase_line_item_id'
      has_many :purchase_returns,         class_name: "StoreFrontModule::LineItems::PurchaseReturnLineItem",
                                          foreign_key: 'purchase_line_item_id'
      has_many :internal_uses,            class_name: "StoreFrontModule::LineItems::InternalUseLineItem",
                                          foreign_key: 'purchase_line_item_id'
      has_many :stock_transfers,          class_name: "StoreFrontModule::LineItems::StockTransferLineItem",
                                          foreign_key: 'purchase_line_item_id'
      has_many :sales_returns,            class_name: "StoreFrontModule::LineItems::SalesReturnLineItem",
                                          foreign_key: 'purchase_line_item_id'
      has_many :spoilages,                class_name: "StoreFrontModule::LineItems::SpoilageLineItem",
                                          foreign_key: 'purchase_line_item_id'
      has_many :received_stock_transfers, class_name: "StoreFrontModule::LineItems::ReceivedStockTransferLineItem",
                                          foreign_key: 'purchase_line_item_id'

      validates :expiry_date, presence: true
      delegate :supplier_name, :date, to: :purchase_order, allow_nil: true



      def sold?
        sales.present? &&
        out_of_stock?
      end

      def self.available
        select { |a| !a.out_of_stock? }
      end

      def out_of_stock?
        sales.any? &&
        available_quantity.zero?
      end

      def available_quantity
        sales_returns_quantity +
        received_stock_transfers_quantity +
        converted_quantity -
        sold_quantity -
        purchase_returns_quantity -
        internal_uses_quantity -
        stock_transfers_quantity -
        spoilages_quantity
      end

      def sold_quantity
        sales.processed.sum(&:converted_quantity)
      end

      def purchase_returns_quantity
        purchase_returns.processed.sum(&:converted_quantity)
      end
      def internal_uses_quantity
        internal_uses.processed.sum(&:converted_quantity)
      end
      def stock_transfers_quantity
        stock_transfers.processed.sum(&:converted_quantity)
      end
      def spoilages_quantity
        spoilages.processed.sum(&:converted_quantity)
      end

      def sales_returns_quantity
        sales_returns.sum(&:converted_quantity)
      end
      def received_stock_transfers_quantity
        received_stock_transfers.sum(&:converted_quantity)
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
