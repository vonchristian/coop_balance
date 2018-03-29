module StoreFrontModule
  module LineItems
    class StockTransferLineItem < LineItem
      belongs_to :stock_transfer_order, class_name: "StoreFrontModule::Orders::StockTransferOrder",
                                        foreign_key: 'order_id'
      belongs_to :purchase_line_item,   class_name: "StoreFrontModule::LineItems::PurchaseLineItem",
                                        foreign_key: 'purchase_line_item_id'

    end
  end
end
