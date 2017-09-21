class AddContactNumberToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :contact_number, :string
  end
end
