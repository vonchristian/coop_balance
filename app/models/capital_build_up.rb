class CapitalBuildUp < ApplicationRecord
  belongs_to :share_capital
  def self.total
    sum(&:share_count)
  end
end
