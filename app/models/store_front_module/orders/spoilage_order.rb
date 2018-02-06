module StoreFrontModule
  module Orders
    class SpoilageOrder < Order
      has_one :note, as: :noteable
      has_many :spoilage_order_line_items, class_name: "StoreFrontModule::LineItems::SpoilageOrderLineItem", foreign_key: 'order_id'
    end
  end
end
