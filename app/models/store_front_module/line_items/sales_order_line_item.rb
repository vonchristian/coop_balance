module StoreFrontModule
  module LineItems
    class SalesOrderLineItem < LineItem
      belongs_to :sales_order, class_name: "StoreFrontModule::Orders::SalesOrder", foreign_key: 'order_id'
      delegate :customer, :official_receipt_number, :date, :customer_name, to: :sales_order, allow_nil: true
    end
  end
end
