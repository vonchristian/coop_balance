class AddConversionQuantityToUnitOfMeasurements < ActiveRecord::Migration[5.2]
  def change
    add_column :unit_of_measurements, :conversion_quantity, :decimal, default: 1
  end
end
