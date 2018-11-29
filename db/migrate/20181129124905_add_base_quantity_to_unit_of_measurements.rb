class AddBaseQuantityToUnitOfMeasurements < ActiveRecord::Migration[5.2]
  def change
    add_column :unit_of_measurements, :base_quantity, :decimal
  end
end
