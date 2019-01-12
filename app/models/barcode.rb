class Barcode < ApplicationRecord
  belongs_to :line_item, class_name: "StoreFrontModule::LineItem"
  include PgSearch
  pg_search_scope :text_search, against: [:code]
end
