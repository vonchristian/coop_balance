class CreateBarangays < ActiveRecord::Migration[5.1]
  def change
    create_table :barangays, id: :uuid do |t|
      t.string :name, index: true, unique: true
      t.belongs_to :municipality, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
