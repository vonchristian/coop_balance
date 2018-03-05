class AddAccountsPayableAccountToStoreFrontConfigs < ActiveRecord::Migration[5.1]
  def change
    add_reference :store_front_configs, :accounts_payable_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
