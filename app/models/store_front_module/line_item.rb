module StoreFrontModule
  class LineItem < ApplicationRecord
    extend StoreFrontModule::QuantityBalanceFinder
    include PgSearch
    pg_search_scope :text_search, against: [:barcode]
    belongs_to :commercial_document, polymorphic: true
    belongs_to :unit_of_measurement
    belongs_to :cart, class_name: "StoreFrontModule::Cart"
    belongs_to :product, touch: true
    belongs_to :referenced_line_item, class_name: "StoreFrontModule::LineItem"
    validates :unit_of_measurement_id, :product_id, presence: true
    delegate :name, to: :commercial_document, prefix: true
    delegate :name, to: :product
    delegate :code, to: :unit_of_measurement, prefix: true
    delegate :conversion_multiplier, to: :unit_of_measurement
    delegate :balance, to: :product, prefix: true
    validates :quantity, numericality: { less_than_or_equal_to: :product_balance }, if: :sales_line_item?

    def self.total
      all.sum(&:converted_quantity)
    end

    def cost_of_goods_sold
      referenced_line_item.purchase_cost * quantity
    end


    def self.total_cost
      all.sum(:total_cost)
    end

    def converted_quantity
      quantity * conversion_multiplier
    end

    def sales_line_item?
      type == "StoreFrontModule::SalesLineItem"
    end
  end
end
