module StoreFrontModule
  module Orders
    class PurchaseReturnOrder < Order
      has_one :note, as: :noteable
      has_many :purchase_return_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseReturnOrderLineItem", foreign_key: 'order_id'
      delegate :name, to: :supplier, prefix: true
      delegate :content, to: :note, prefix: true, allow_nil: true
      def supplier
        commercial_document
      end
    end
  end
end
