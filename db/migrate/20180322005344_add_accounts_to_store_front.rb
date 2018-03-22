class AddAccountsToStoreFront < ActiveRecord::Migration[5.1]
  def change
    add_reference :store_fronts, :cost_of_goods_sold_account,    foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :store_fronts, :accounts_payable_account,      foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :store_fronts, :merchandise_inventory_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :store_fronts, :sales_account,                 foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :store_fronts, :sales_return_account,          foreign_key: { to_table: :accounts }, type: :uuid
  end
end
