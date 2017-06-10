class RawMaterialStock < ApplicationRecord
  belongs_to :supplier
  belongs_to :raw_material
  def self.total
    sum(:quantity)
  end
  def total_purchase_cost
    [total_cost, freight_in, discount_amount].sum
  end
end
