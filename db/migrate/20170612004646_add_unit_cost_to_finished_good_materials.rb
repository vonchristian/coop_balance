class AddUnitCostToFinishedGoodMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :finished_good_materials, :unit_cost, :decimal
    add_column :finished_good_materials, :total_cost, :decimal
  end
end
