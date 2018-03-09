module StoreFrontModule
  class Cart < ApplicationRecord
    belongs_to :employee, class_name: 'User', foreign_key: 'user_id'
    has_many :line_items, dependent: :destroy, class_name: "StoreFrontModule::LineItem"
    has_many :purchase_line_items,
             dependent: :destroy,
             class_name: "StoreFrontModule::LineItems::PurchaseLineItem"
    has_many :sales_line_items,
             dependent: :destroy,
             class_name: "StoreFrontModule::LineItems::SalesLineItem"
    has_many :spoilage__line_items,
             dependent: :destroy,
             class_name: "StoreFrontModule::LineItems::SpoilageLineItem"
    has_many :sales_return_line_items,
             dependent: :destroy,
             class_name: "StoreFrontModule::LineItems::SalesReturnLineItem"
    has_many :purchase_return_line_items,
             dependent: :destroy,
             class_name: "StoreFrontModule::LineItems::PurchaseReturnLineItem"
    def total_cost
      line_items.sum(&:total_cost)
    end
  end
end
