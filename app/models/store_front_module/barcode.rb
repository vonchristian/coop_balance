module StoreFrontModule
  class Barcode < ApplicationRecord
    belongs_to :line_item, class_name: 'StoreFrontModule::LineItem'
    include PgSearch::Model
    pg_search_scope :text_search, against: [:code]

    validates :code, presence: true
    validates :code, uniqueness: { scope: :line_item_id }
  end
end
