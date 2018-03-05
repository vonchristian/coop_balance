class RemoveFullnameFromMembers < ActiveRecord::Migration[5.1]
  def change
    remove_column :members, :fullname, :string
  end
end
