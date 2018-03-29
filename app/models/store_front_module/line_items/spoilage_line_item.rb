module StoreFrontModule
  module LineItems
    class SpoilageLineItem < LineItem
      belongs_to :spoilage_order,     class_name: "StoreFrontModule::Orders::SpoilageOrder",
                                      foreign_key: 'order_id'
      belongs_to :purchase_line_item, class_name: "StoreFrontModule::LineItems::PurchaseLineItem",
                                      foreign_key: 'purchase_line_item_id'
      delegate :commercial_document, :commercial_document_name, :date, to: :spoilage_order
    end
  end
end
