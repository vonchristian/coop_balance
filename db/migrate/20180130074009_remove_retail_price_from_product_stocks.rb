class RemoveRetailPriceFromProductStocks < ActiveRecord::Migration[5.2]
  def change
    remove_column :product_stocks, :retail_price, :decimal
    remove_column :product_stocks, :wholesale_price, :decimal
  end
end
