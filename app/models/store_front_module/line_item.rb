module StoreFrontModule
  class LineItem < ApplicationRecord
    extend StoreFrontModule::QuantityBalanceFinder
    include PgSearch
    pg_search_scope :text_search, associated_against: { barcodes: [:code] }

    belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"
    belongs_to :cart,                class_name: "StoreFrontModule::Cart"
    belongs_to :product,             class_name: "StoreFrontModule::Product"
    belongs_to :order,               class_name: "StoreFrontModule::Order",
                                     foreign_key: 'order_id'
    belongs_to :cooperative
    belongs_to :store_front
    has_many :barcodes,              dependent: :destroy

    validates :unit_of_measurement_id, :product_id, presence: true
    validates :quantity, :unit_cost, :total_cost, presence: true, numericality: true

    delegate :name,                   to: :product
    delegate :code,                   to: :unit_of_measurement,prefix: true
    delegate :conversion_multiplier,  to: :unit_of_measurement
    delegate :balance,                to: :product, prefix: true
    delegate :employee,               to: :order
    delegate :name,                   to: :employee, prefix: true


    def self.processed
      where.not(order_id: nil).or(forwarded)
    end

    def self.forwarded
      where(forwarded: true)
    end

    def self.unprocessed
      where(order_id: nil)
    end

    def self.total_converted_quantity
      sum(&:converted_quantity)
    end

    def self.total_cost
      sum(:total_cost)
    end

    def processed?
      return true if forwarded?
      order.present? && order.processed?
    end

    def converted_quantity
      quantity * conversion_multiplier
    end
    def normalized_barcodes
      barcodes.pluck(:code).join(",")
    end
  end
end
