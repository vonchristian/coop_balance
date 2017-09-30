class AddPassbookNumberToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :passbook_number, :string
    add_index :members, :passbook_number, unique: true
  end
end
