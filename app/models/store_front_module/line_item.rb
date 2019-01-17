module StoreFrontModule
  # The LineItem class is responsible for computing
  # balances of line items

  class LineItem < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, associated_against: { barcodes: [:code] }

    belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"
    belongs_to :cart,                class_name: "StoreFrontModule::Cart"
    belongs_to :product,             class_name: "StoreFrontModule::Product"
    belongs_to :order,               class_name: "StoreFrontModule::Order",
                                     foreign_key: 'order_id'
    belongs_to :cooperative
    has_many :barcodes,              dependent: :destroy

    validates :unit_of_measurement_id, :product_id, presence: true
    validates :quantity, :unit_cost, :total_cost, presence: true, numericality: true

    delegate :name,                   to: :product
    delegate :code,                   to: :unit_of_measurement,prefix: true
    delegate :conversion_multiplier,  to: :unit_of_measurement
    delegate :balance,                to: :product, prefix: true
    delegate :employee,  to: :order
    delegate :name,                   to: :employee, prefix: true


    def self.processed
      where.not(order_id: nil)
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
      order.present? && order.processed?
    end

    def self.balance(args={})
    balance_finder(args).new(args.merge(line_items: self)).compute
  end


  def self.balance_finder(args={})
     if args.present?
      klass = args.select{|key, value| !value.nil?}.keys.sort.map{ |key| key.to_s.titleize }.join.gsub(" ", "")
    else
    klass = "DefaultQuantityCalculator"
    end
      ("StoreFrontModule::QuantityCalculators::" + klass).constantize
  end

    def converted_quantity
      quantity * conversion_multiplier
    end
    def normalized_barcodes
      barcodes.pluck(:code).join(",")
    end
  end
end
