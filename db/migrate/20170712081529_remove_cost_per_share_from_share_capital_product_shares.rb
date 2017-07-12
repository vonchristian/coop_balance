class RemoveCostPerShareFromShareCapitalProductShares < ActiveRecord::Migration[5.1]
  def change
    remove_column :share_capital_product_shares, :cost_per_share, :decimal
  end
end
