class CreateFinishedGoodMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :finished_good_materials, id: :uuid do |t|
      t.belongs_to :raw_material, foreign_key: true, type: :uuid
      t.decimal :quantity
      t.string :unit
      t.datetime :date

      t.timestamps
    end
  end
end
