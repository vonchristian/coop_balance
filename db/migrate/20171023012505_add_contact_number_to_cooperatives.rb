class AddContactNumberToCooperatives < ActiveRecord::Migration[5.1]
  def change
    add_column :cooperatives, :contact_number, :string
    add_column :cooperatives, :address, :string
  end
end
