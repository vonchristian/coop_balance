class AddCashTenderedToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :cash_tendered, :decimal
    add_column :orders, :total_cost, :decimal
    add_column :orders, :order_change, :decimal
  end
end
