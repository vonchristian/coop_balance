class AddQuantityToProductStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :product_stocks, :quantity, :decimal
  end
end
