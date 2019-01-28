class RenameAccountsPayableAccountInStoreFronts < ActiveRecord::Migration[5.2]
  def change
    rename_column :store_fronts, :accounts_payable_account_id, :payable_account_id

  end
end
