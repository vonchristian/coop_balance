class AddUnitOfMeasurementToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :unit_of_measurement, :string
  end
end
