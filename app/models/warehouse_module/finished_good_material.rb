class FinishedGoodMaterial < ApplicationRecord
  def self.total
    sum(:quantity)
  end
end
