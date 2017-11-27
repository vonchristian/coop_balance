class RemoveAccountsFromShareCapitalProducts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :share_capital_products, :account, foreign_key: { to_table: :accounts }
  end
end
