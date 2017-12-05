module StoreModule
  class LineItem < ApplicationRecord
    belongs_to :line_itemable, polymorphic: true
    belongs_to :cart, class_name: "StoreModule::Cart"
    delegate :name, :barcode, to: :line_itemable, prefix: true
    after_commit :set_total_cost
    def self.total_quantity
      all.sum(&:quantity)
    end

    def self.total_cost
      all.sum(:total_cost)
    end

    private
    def set_total_cost
      self.total_cost ||= quantity * unit_cost
    end
  end
end
