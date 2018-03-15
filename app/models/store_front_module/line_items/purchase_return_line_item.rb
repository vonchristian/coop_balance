module StoreFrontModule
  module LineItems
    class PurchaseReturnLineItem < LineItem
      belongs_to :purchase_return_order, class_name: "StoreFrontModule::Orders::PurchaseReturnOrder", foreign_key: 'order_id'
      belongs_to :purchase_line_item,    class_name: "StoreFrontModule::LineItems::PurchaseLineItem",
                                         foreign_key: 'purchase_line_item_id'
      delegate :supplier, :supplier_name, :date, to: :purchase_return_order
    end
  end
end
