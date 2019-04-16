class AddCodeToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :code, :string
    add_index :members, :code, unique: true
  end
end
