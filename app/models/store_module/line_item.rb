module StoreModule
  class LineItem < ApplicationRecord
    belongs_to :product, class_name: "StoreModule::Product"
    belongs_to :product_stock, class_name: "StoreModule::ProductStock"
    belongs_to :cart, class_name: "StoreModule::Cart"
    delegate :name, to: :product_stock
    after_commit :set_total_cost
    def self.total_cost
      all.sum(:total_cost)
    end

    private
    def set_total_cost
      self.total_cost ||= quantity * unit_cost
    end
  end
end