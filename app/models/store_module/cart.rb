module StoreModule
  class Cart < ApplicationRecord
    belongs_to :employee, class_name: 'User', foreign_key: 'user_id'
    has_many :line_items, dependent: :destroy, class_name: "StoreModule::LineItem"
    has_many :product_stocks, through: :line_items, class_name: "StoreModule::ProductStock", source: :line_itemable, source_type: "ProductStock"

    def total_cost
      line_items.sum(&:total_cost)
    end

    def add_line_item(line_item)
      if self.line_items.pluck(:line_itemable_id).include?(line_item.line_itemable_id)
        self.line_items.where(line_itemable_id: line_item.line_itemable_id).delete_all
        # replace with a single item
        self.line_items.create!(line_itemable_id: line_item.line_itemable_id, quantity: line_item.quantity,  unit_cost: line_item.unit_cost, total_cost: line_item.total_cost)
      else
        self.line_items.create!(line_itemable_id: line_item.line_itemable_id, quantity: line_item.quantity,  unit_cost: line_item.unit_cost, total_cost: line_item.total_cost)
      end
    end
  end
end
