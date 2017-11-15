class AddAccountNumberToMemberships < ActiveRecord::Migration[5.1]
  def change
    add_column :memberships, :account_number, :string
    add_index :memberships, :account_number, unique: true
  end
end
