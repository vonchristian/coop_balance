class AddStockRegistryToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :stock_registry, foreign_key: { to_table: :registries }, type: :uuid
  end
end
