class AddAccountTypeToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :account_type, :string
    add_index :accounts, :account_type
  end
end
