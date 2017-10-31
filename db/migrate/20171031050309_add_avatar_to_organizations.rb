class AddAvatarToOrganizations < ActiveRecord::Migration[5.1]
  def up
    add_attachment :organizations, :avatar
  end
  def down
    remove_attachment :organizations, :avatar
  end
end
