class RemoveNameFromProductStocks < ActiveRecord::Migration[5.2]
  def change
    remove_column :product_stocks, :name, :string
  end
end
