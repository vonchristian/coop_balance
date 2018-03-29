module StoreFrontModule
  module LineItems
    class SalesReturnLineItem < LineItem
      belongs_to :sales_return_order, class_name: "StoreFrontModule::Orders::SalesReturnOrder", foreign_key: 'order_id'
      belongs_to :purchase_line_item, class_name: "StoreFrontModule::LineItems::PurchaseLineItem", foreign_key: 'purchase_line_item_id'
      delegate :customer, :customer_name, :date, to: :sales_return_order
    end
  end
end
