class Barangay < ApplicationRecord
  belongs_to :municipality
  has_many :streets 

  validates :name, presence: true, uniqueness: true
end
