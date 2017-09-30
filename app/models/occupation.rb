class Occupation < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
