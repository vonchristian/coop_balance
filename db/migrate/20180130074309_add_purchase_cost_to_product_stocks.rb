class AddPurchaseCostToProductStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :product_stocks, :purchase_cost, :decimal
    add_column :product_stocks, :total_purchase_cost, :decimal
  end
end
