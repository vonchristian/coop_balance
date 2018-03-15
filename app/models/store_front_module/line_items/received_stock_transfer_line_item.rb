module StoreFrontModule
  module LineItems
    class ReceivedStockTransferLineItem < LineItem
      belongs_to :received_stock_transfer_order, class_name: "StoreFrontModule::Orders::ReceivedStockTransferOrder",
                 foreign_key: 'order_id'
    end
  end
end
