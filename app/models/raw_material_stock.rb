class RawMaterialStock < ApplicationRecord
  belongs_to :supplier
  belongs_to :raw_material
  def self.total
    sum(:quantity)
  end
end
