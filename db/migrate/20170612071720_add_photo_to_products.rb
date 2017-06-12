class AddPhotoToProducts < ActiveRecord::Migration[5.1]
  def up
    add_attachment :products, :photo
  end
  def down
    remove_attachment :products, :photo
  end
  end
