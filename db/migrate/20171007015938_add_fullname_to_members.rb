class AddFullnameToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :fullname, :string
    add_index :members, :fullname, unique: true
  end
end
