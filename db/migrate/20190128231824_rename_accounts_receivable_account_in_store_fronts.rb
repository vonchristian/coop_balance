class RenameAccountsReceivableAccountInStoreFronts < ActiveRecord::Migration[5.2]
  def change
    rename_column :store_fronts, :accounts_receivable_account_id, :receivable_account_id
  end
end
