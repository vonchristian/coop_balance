class RemoveQuantityFromUnitOfMeasurements < ActiveRecord::Migration[5.2]
  def change
    remove_column :unit_of_measurements, :quantity, :decimal
  end
end
