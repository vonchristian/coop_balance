class RemoveSubscriptionAccountFromShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :share_capital_products, :subscription_account, foreign_key: { to_table: :accounts }
  end
end
