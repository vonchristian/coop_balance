module StoreFrontModule
	class ProductStock < ApplicationRecord
	  include PgSearch
	  pg_search_scope :text_search, against: [:barcode,], :associated_against => {
    :product => [:name] }
	  belongs_to :product, class_name: "StoreFrontModule::Product"
	  belongs_to :supplier
    belongs_to :registry, class_name: "StockRegistry", foreign_key: 'registry_id'
    belongs_to :unit_of_measurement
    has_many :sold_items, class_name: "StoreFrontModule::LineItem", as: :line_itemable
    has_many :returned_items
    delegate :code, to: :unit_of_measurement, prefix: true, allow_nil: true
	  delegate :name, :unit_of_measurements, to: :product, allow_nil: true

    def self.in_stock
      sum(&:in_stock)
    end

    def self.total_quantity
      sum(&:quantity)
    end

    def in_stock
      converted_quantity - sold_items_quantity
    end

    def converted_quantity
      conversion_multiplier * quantity
    end
    def conversion_multiplier
      unit_of_measurement.try(:conversion_multiplier) || 1
    end

    def sold_items_quantity
      sold_items.total_quantity
    end


    def out_of_stock?
      in_stock.zero? || in_stock < 0
    end

	  private
	  def set_default_date
	  	self.date ||= Time.zone.now
	  end
	end
end
