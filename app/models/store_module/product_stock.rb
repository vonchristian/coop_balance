module StoreModule
	class ProductStock < ApplicationRecord
	  include PgSearch
	  pg_search_scope :text_search, against: [:barcode, :name]
	  belongs_to :product, class_name: "StoreModule::Product"
	  belongs_to :supplier
    belongs_to :registry, class_name: "StockRegistry", foreign_key: 'registry_id'
    has_many :sold_items, class_name: "StoreModule::LineItem", as: :line_itemable
	  delegate :name, to: :product, allow_nil: true

	  validates :supplier_id, presence: true
	  validates :unit_cost, :total_cost, :quantity, :retail_price, :wholesale_price, numericality: { greater_than: 0.01 }
	  before_save :set_default_date, :set_name

    def self.total_quantity
      sum(&:quantity)
    end

    def in_stock
      quantity - sold_items.total_quantity
    end

    def out_of_stock?
      in_stock.zero? || in_stock < 0
    end

	  private
	  def set_default_date
	  	self.date ||= Time.zone.now
	  end
    def set_name
      self.name = self.product.name
    end
	end
end
