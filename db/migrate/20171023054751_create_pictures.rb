class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures, id: :uuid do |t|
      t.references :pictureable, polymorphic: true, type: :uuid
      t.attachment :image

      t.timestamps
    end
  end
end
