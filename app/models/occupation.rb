class Occupation < ApplicationRecord
  include PgSearch
  multisearchable against: [:title]
  validates :title, presence: true

  def self.recent
    order(created_at: :desc).first || NullOccupation.new
  end
  def name #for search results
    title
  end
end
