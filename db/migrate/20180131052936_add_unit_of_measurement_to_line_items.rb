class AddUnitOfMeasurementToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :unit_of_measurement, foreign_key: true, type: :uuid
  end
end
