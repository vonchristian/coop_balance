class AddIndexToSavings < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :savings, :account_owner_name, algorithm: :concurrently
  end
end
