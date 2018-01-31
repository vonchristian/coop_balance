module StoreFrontModule
  class LineItem < ApplicationRecord
    extend StoreFrontModule::QuantityBalanceFinder
    belongs_to :commercial_document, polymorphic: true
    belongs_to :order
    belongs_to :unit_of_measurement
    belongs_to :cart, class_name: "StoreFrontModule::Cart"
    belongs_to :product

    validates :unit_of_measurement_id, presence: true
    delegate :name, to: :product, allow_nil: true
    delegate :code, to: :unit_of_measurement, prefix: true
    delegate :conversion_multiplier, to: :unit_of_measurement

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
      quantity * conversion_multiplier
    end
  end
end
