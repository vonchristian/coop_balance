class AddIndexToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_index :accounts, :updated_at
  end
end
