class RealProperty < ApplicationRecord
  belongs_to :member
  belongs_to :owner, polymorphic: true
  has_many :appraisals
  has_many :appraisers, through: :appraisals
  has_many :pictures, as: :pictureable

  accepts_nested_attributes_for :pictures
  def appraised_value
    return 0 if appraisals.blank?
    appraisals.order(created_at: :asc).last.market_value 
  end
  def self.types 
    ["Building", "Land", "Machinery"]
  end
end
