class RemoveAvatarFromSuppliers < ActiveRecord::Migration[5.2]
  def up
    remove_attachment :suppliers, :avatar
  end
  def down
    add_attachment :suppliers, :avatar
  end
end
