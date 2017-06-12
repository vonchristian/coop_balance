class AddProductToFinishedGoodsMaterials < ActiveRecord::Migration[5.1]
  def change
    add_reference :finished_good_materials, :product, foreign_key: true, type: :uuid
  end
end
