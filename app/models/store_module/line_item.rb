module StoreModule
  class LineItem < ApplicationRecord
    belongs_to :line_itemable, polymorphic: true
    belongs_to :product, class_name: "StoreModule::Product"
    belongs_to :product_stock, class_name: "StoreModule::ProductStock"
    belongs_to :cart, class_name: "StoreModule::Cart"
    delegate :name, :barcode, to: :product_stock, prefix: true
    after_commit :set_total_cost
    def self.total 
      all.sum(&:quantity)
    end
    def self.total_cost
      all.sum(:total_cost)
    end
    def unit_cost_and_quantity
      product_stock.unit_cost * quantity
    end

    private
    def set_total_cost
      self.total_cost ||= quantity * unit_cost
    end
  end
end