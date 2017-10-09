class RealProperty < ApplicationRecord
  belongs_to :member
  has_many :appraisals
  has_many :appraisers, through: :appraisals
  def self.types 
    ["Building", "Land", "Machinery"]
  end
end
