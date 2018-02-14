module StoreFrontModule
  module LineItems
    class SalesReturnOrderLineItem < LineItem
      belongs_to :sales_return_order, class_name: "StoreFrontModule::Orders::SalesReturnOrder", foreign_key: 'order_id'
      delegate :customer, :customer_name, :date, to: :sales_return_order
    end
  end
end
