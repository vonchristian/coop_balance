class Occupation < ApplicationRecord
  include PgSearch
  multisearchable against: [:title]
  validates :title, presence: true
  def name #for search results
    title 
  end
end
