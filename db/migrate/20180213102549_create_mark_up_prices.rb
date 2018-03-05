class CreateMarkUpPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :mark_up_prices, id: :uuid do |t|
      t.decimal :price
      t.datetime :date
      t.belongs_to :unit_of_measurement, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
