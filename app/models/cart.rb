class Cart < ApplicationRecord
  belongs_to :employee
  has_many :line_items, dependent: :destroy
  has_many :product_stocks, through: :line_items

  def total_price
    line_items.to_a.sum { |item| item.total_cost }
  end

  def total_whole_sale_price
    line_items.to_a.sum { |item| item.total_whole_sale_price }
  end

  def add_line_item(line_item)
    if self.product_stocks.include?(line_item.product_stock)
      self.line_items.where(product_stock_id: line_item.product_stock.id).delete_all
      # replace with a single item
      self.line_items.create!(product_stock_id: line_item.product_stock.id, quantity: line_item.quantity,  unit_cost: line_item.unit_cost, total_cost: line_item.total_cost)
    else
      self.line_items.create!(product_stock_id: line_item.product_stock.id, quantity: line_item.quantity, unit_cost: line_item.unit_cost, total_cost: line_item.total_cost)
    end
  end
end
