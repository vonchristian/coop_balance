class RemoveAvatarFromMembers < ActiveRecord::Migration[5.2]
  def up
    remove_attachment :members, :avatar
  end
  def down
    add_attachment :members, :avatar
  end
end
