module StoreFrontModule
  class LineItem < ApplicationRecord
    extend StoreFrontModule::BalanceFinder
    belongs_to :line_itemable, polymorphic: true
    belongs_to :order
    belongs_to :purchase_return
    belongs_to :unit_of_measurement
    belongs_to :cart, class_name: "StoreFrontModule::Cart"
    delegate :name, :barcode, to: :line_itemable, allow_nil: true
    delegate :code, to: :unit_of_measurement, prefix: true

    def self.total
      all.sum(&:converted_quantity)
    end

    def unit_cost_and_quantity
      unit_cost * quantity
    end

    def self.total_cost
      all.sum(:total_cost)
    end

    def converted_quantity
      quantity * unit_of_measurement.conversion_multiplier
    end
  end
end
