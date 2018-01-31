module StoreFrontModule
  class Cart < ApplicationRecord
    belongs_to :employee, class_name: 'User', foreign_key: 'user_id'
    has_many :line_items, dependent: :destroy, class_name: "StoreFrontModule::LineItem"
    has_many :product_stocks, through: :line_items, class_name: "StoreFrontModule::ProductStock", source: :line_itemable, source_type: "ProductStock"

    def total_cost
      line_items.sum(&:total_cost)
    end
  end
end
