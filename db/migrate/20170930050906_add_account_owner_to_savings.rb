class AddAccountOwnerToSavings < ActiveRecord::Migration[5.1]
  def change
    add_column :savings, :account_owner_name, :string
  end
end
