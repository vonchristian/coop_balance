class CreateStreets < ActiveRecord::Migration[5.1]
  def change
    create_table :streets, id: :uuid do |t|
      t.string :name, index: true, unique: true
      t.belongs_to :barangay, foreign_key: true, type: :uuid
      t.belongs_to :municipality, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
