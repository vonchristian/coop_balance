class AddContactNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :contact_number, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :sex, :integer
  end
end
