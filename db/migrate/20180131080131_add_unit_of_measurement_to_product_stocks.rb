class AddUnitOfMeasurementToProductStocks < ActiveRecord::Migration[5.2]
  def change
    add_reference :product_stocks, :unit_of_measurement, foreign_key: true, type: :uuid
  end
end
