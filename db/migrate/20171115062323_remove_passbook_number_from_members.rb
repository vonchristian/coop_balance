class RemovePassbookNumberFromMembers < ActiveRecord::Migration[5.1]
  def change
    remove_column :members, :passbook_number, :string
  end
end
