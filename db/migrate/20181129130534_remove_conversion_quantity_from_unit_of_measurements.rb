class RemoveConversionQuantityFromUnitOfMeasurements < ActiveRecord::Migration[5.2]
  def change
    remove_column :unit_of_measurements, :conversion_quantity, :decimal
  end
end
