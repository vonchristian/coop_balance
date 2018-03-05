class RemovePriceFromUnitOfMeasurements < ActiveRecord::Migration[5.1]
  def change
    remove_column :unit_of_measurements, :price, :decimal
  end
end
