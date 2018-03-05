class RemoveUnitFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :unit, :string
  end
end
