class RemoveUnitCostFromProductStocks < ActiveRecord::Migration[5.2]
  def change
    remove_column :product_stocks, :unit_cost, :decimal
    remove_column :product_stocks, :total_cost, :decimal
  end
end
