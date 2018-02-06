module StoreFrontModule
  class Cart < ApplicationRecord
    belongs_to :employee, class_name: 'User', foreign_key: 'user_id'
    has_many :line_items, dependent: :destroy, class_name: "StoreFrontModule::LineItem"
    has_many :purchase_order_line_items, dependent: :destroy, class_name: "StoreFrontModule::LineItems::PurchaseOrderLineItem"
    has_many :sales_order_line_items, dependent: :destroy, class_name: "StoreFrontModule::LineItems::SalesOrderLineItem"
    has_many :spoilage_order_line_items, dependent: :destroy, class_name: "StoreFrontModule::LineItems::SpoilageOrderLineItem"
    has_many :products, through: :line_items, class_name: "StoreFrontModule::Product"
    def total_cost
      line_items.sum(&:total_cost)
    end

    def line_items_quantity(product)
      line_items.where(product: product).sum(&:quantity)
    end
    def line_items_total_cost(product)
      line_items.where(product: product).sum(&:total_cost)
    end
  end
end
