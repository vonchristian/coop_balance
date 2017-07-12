class WorkInProcessMaterial < ApplicationRecord
  def self.total
    sum(:quantity)
  end
end
