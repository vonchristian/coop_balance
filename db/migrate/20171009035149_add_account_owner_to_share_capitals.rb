class AddAccountOwnerToShareCapitals < ActiveRecord::Migration[5.1]
  def change
    add_column :share_capitals, :account_owner_name, :string
  end
end
