class AddCostPerShareToShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capital_products, :cost_per_share, :decimal
  end
end
