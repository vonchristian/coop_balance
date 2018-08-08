class AddAccountNumberToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :account_number, :string
    add_index :members, :account_number, unique: true
  end
end
