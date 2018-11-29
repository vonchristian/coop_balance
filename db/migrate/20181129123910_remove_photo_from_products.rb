class RemovePhotoFromProducts < ActiveRecord::Migration[5.2]
  def up
    remove_attachment :products, :photo
  end
  def down
    add_attachment :products, :photo
  end
end
