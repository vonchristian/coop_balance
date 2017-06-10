class CreateRawMaterialStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :raw_material_stocks, id: :uuid do |t|
      t.belongs_to :supplier, foreign_key: true, type: :uuid
      t.belongs_to :raw_material, foreign_key: true, type: :uuid
      t.decimal :quantity
      t.decimal :unit_cost
      t.decimal :total_cost
      t.datetime :delivery_date

      t.timestamps
    end
  end
end
