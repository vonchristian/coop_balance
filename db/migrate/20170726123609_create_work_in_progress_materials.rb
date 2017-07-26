class CreateWorkInProgressMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :work_in_progress_materials, id: :uuid do |t|
      t.belongs_to :raw_material, foreign_key: true, type: :uuid
      t.datetime :date
      t.decimal :quantity
      t.decimal :unit_cost
      t.decimal :total_cost

      t.timestamps
    end
  end
end
