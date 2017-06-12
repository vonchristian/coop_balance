class AddAvatarToSuppliers < ActiveRecord::Migration[5.1]
  def up
    add_attachment :suppliers, :avatar
  end
  def down
    remove_attachment :suppliers, :avatar
  end
end
