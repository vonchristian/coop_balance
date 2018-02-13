module StoreFrontModule
  module LineItems
    class PurchaseReturnOrderLineItem < LineItem
      belongs_to :purchase_return_order, class_name: "StoreFrontModule::Orders::PurchaseReturnOrder", foreign_key: 'order_id'
    end
  end
end
