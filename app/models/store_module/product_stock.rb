module StoreModule
	class ProductStock < ApplicationRecord
	  include PgSearch
	  pg_search_scope :search_by_name, against: [:barcode]
	  belongs_to :product, class_name: "StoreModule::Product"
	  belongs_to :supplier
	  delegate :name, to: :product

	  validates :supplier_id, presence: true
	  validates :unit_cost, :total_cost, numericality: { greater_than: 0.01 }
	  before_save :set_default_date
    def self.total 
      sum(&:quantity)
    end

	  private 
	  def set_default_date 
	  	self.date ||= Time.zone.now
	  end
	end
end