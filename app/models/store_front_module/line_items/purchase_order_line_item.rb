module StoreFrontModule
  module LineItems
    class PurchaseOrderLineItem < LineItem
      belongs_to :purchase_order, class_name: "StoreFrontModule::Orders::PurchaseOrder", foreign_key: 'order_id'
    end
  end
end
