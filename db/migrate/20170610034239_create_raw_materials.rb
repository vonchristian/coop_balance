class CreateRawMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :raw_materials, id: :uuid do |t|
      t.string :name
      t.string :unit
      t.string :description

      t.timestamps
    end
    add_index :raw_materials, :name, unique: true
  end
end
