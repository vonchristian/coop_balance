class AddCostPerShareToShareCapitalProductShares < ActiveRecord::Migration[5.1]
  def change
    add_column :share_capital_product_shares, :cost_per_share, :decimal
  end
end
