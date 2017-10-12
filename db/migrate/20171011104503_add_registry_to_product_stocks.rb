class AddRegistryToProductStocks < ActiveRecord::Migration[5.1]
  def change
    add_reference :product_stocks, :registry, foreign_key: true, type: :uuid
  end
end
