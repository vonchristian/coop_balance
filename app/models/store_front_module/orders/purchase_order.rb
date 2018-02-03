module StoreFrontModule
  module Orders
    class PurchaseOrder < Order
      belongs_to :supplier, foreign_key: 'commercial_document_id'
      has_one :voucher, as: :commercial_document
      has_many :purchase_order_line_items, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem", foreign_key: 'order_id'

      delegate :number, to: :voucher, prefix: true, allow_nil: true
    end
  end
end
