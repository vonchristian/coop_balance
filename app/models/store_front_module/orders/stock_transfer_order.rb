module StoreFrontModule
  module Orders
    class StockTransferOrder < Order
      has_many :stock_transfer_line_items, class_name: "StoreFrontModule::LineItems::StockTransferLineItem",
               foreign_key: 'order_id'

      delegate :name, to: :store_front, prefix: true

      def store_front
        commercial_document
      end
    end
  end
end
