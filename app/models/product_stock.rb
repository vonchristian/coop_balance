class ProductStock < ApplicationRecord
  include PgSearch
  pg_search_scope :search_by_name, against: [:barcode]
  belongs_to :product
  belongs_to :supplier
  delegate :name, to: :product
end
