class AddMinimumBalanceToShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capital_products, :minimum_balance, :decimal, default: 0
  end
end
