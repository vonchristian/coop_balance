class AddSalesReturnAccountToStoreFrontConfigs < ActiveRecord::Migration[5.2]
  def change
    add_reference :store_front_configs, :sales_return_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
