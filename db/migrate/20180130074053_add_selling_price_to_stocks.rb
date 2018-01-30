class AddSellingPriceToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :product_stocks, :selling_price, :decimal
  end
end
