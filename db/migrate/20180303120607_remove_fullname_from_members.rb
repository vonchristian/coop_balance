class RemoveFullnameFromMembers < ActiveRecord::Migration[5.2]
  def change
    remove_column :members, :fullname, :string
  end
end
