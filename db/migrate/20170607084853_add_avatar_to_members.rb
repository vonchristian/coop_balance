class AddAvatarToMembers < ActiveRecord::Migration[5.1]
  def up
    add_attachment :members, :avatar
  end
  def down
    remove_attachment :members, :avatar
  end
end
