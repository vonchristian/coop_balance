class RemoveUnitFromProducts < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :unit, :string
  end
end
