class AddRetailPriceToProductStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :product_stocks, :retail_price, :decimal
    add_column :product_stocks, :wholesale_price, :decimal
  end
end
