class CreateUnitOfMeasurements < ActiveRecord::Migration[5.2]
  def change
    create_table :unit_of_measurements, id: :uuid do |t|
      t.belongs_to :product, foreign_key: true, type: :uuid
      t.string :code
      t.string :description
      t.decimal :price
      t.decimal :quantity
      t.decimal :conversion_quantity
      t.boolean :base_measurement, default: false

      t.timestamps
    end
  end
end
