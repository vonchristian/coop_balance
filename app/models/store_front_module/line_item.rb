module StoreFrontModule
  class LineItem < ApplicationRecord
    extend StoreFrontModule::QuantityBalanceFinder
    include PgSearch
    pg_search_scope :text_search, against: [:barcode]
    belongs_to :commercial_document, polymorphic: true
    belongs_to :unit_of_measurement
    belongs_to :cart, class_name: "StoreFrontModule::Cart"
    belongs_to :product, touch: true

    validates :unit_of_measurement_id, :product_id, presence: true
    delegate :name, to: :commercial_document, prefix: true
    delegate :name, to: :product
    delegate :code, to: :unit_of_measurement, prefix: true
    delegate :conversion_multiplier, to: :unit_of_measurement
    delegate :balance, to: :product, prefix: true


    def self.total
      all.sum(&:converted_quantity)
    end

    def self.total_cost
      all.sum(:total_cost)
    end

    def converted_quantity
      quantity * conversion_multiplier
    end
  end
end