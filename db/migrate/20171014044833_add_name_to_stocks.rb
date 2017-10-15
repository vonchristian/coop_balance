class AddNameToStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :product_stocks, :name, :string
  end
end
