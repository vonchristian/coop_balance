class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :product_stock
  belongs_to :cart
  delegate :name, to: :product_stock
  after_commit :set_total_cost
  def self.total_cost
    all.sum(:total_cost)
  end

  private
  def set_total_cost
    self.total_cost = quantity * unit_cost
  end
end
