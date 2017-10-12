module StoreModule
	class ProductStock < ApplicationRecord
	  include PgSearch
	  pg_search_scope :search_by_name, against: [:barcode]
	  belongs_to :product, class_name: "StoreModule::Product"
	  belongs_to :supplier
    belongs_to :registry, class_name: "StockRegistry", foreign_key: 'registry_id'
    has_many :sold_items, class_name: "StoreModule::LineItem"
	  delegate :name, to: :product, allow_nil: true

	  validates :supplier_id, presence: true
	  validates :unit_cost, :total_cost, numericality: { greater_than: 0.01 }
	  before_save :set_default_date
    def self.total 
      sum(&:quantity)
    end
    def in_stock
      quantity - sold_items.total
    end
    def out_of_stock?
      in_stock.zero?
    end


	  private 
	  def set_default_date 
	  	self.date ||= Time.zone.now
	  end
	end
end