module StoreFrontModule
  module Orders
    class SpoilageOrder < Order
      has_one :note, as: :noteable
      has_many :spoilage_line_items, class_name: "StoreFrontModule::LineItems::SpoilageLineItem", foreign_key: 'order_id'
    end
  end
end
