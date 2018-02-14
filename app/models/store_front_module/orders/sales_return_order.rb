module StoreFrontModule
  module Orders
    class SalesReturnOrder < Order
      has_many :sales_return_order_line_items, class_name: "StoreFrontModule::LineItems::SalesReturnOrderLineItem", foreign_key: 'order_id'
      has_one :note, as: :noteable
      delegate :content, to: :note, prefix: true, allow_nil: true
      def customer
        commercial_document
      end
    end
  end
end
