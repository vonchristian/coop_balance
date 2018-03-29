module StoreFrontModule
  module LineItems
    class ReceivedStockTransferLineItem < LineItem
      belongs_to :received_stock_transfer_order, class_name: "StoreFrontModule::Orders::ReceivedStockTransferOrder",
                 foreign_key: 'order_id'
      belongs_to :purchase_line_item, class_name: "StoreFrontModule::LineItems::PurchaseLineItem", foreign_key: 'purchase_line_item_id'

    end
  end
end
