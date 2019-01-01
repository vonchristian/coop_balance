class CreateStockRegistries < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_registries, id: :uuid do |t|
      t.string :product_name
      t.string :category_name
      t.string :unit_of_measurement
      t.decimal :in_stock
      t.decimal :purchase_cost
      t.decimal :total_cost
      t.decimal :selling_cost
      t.string :barcodes, array: true, default: '{}'
      t.boolean :base_measurement
      t.decimal :base_quantity
      t.decimal :conversion_quantity
      t.datetime :date
      t.belongs_to :store_front, foreign_key: true, type: :uuid
      t.belongs_to :registry, foreign_key: true, type: :uuid
      t.belongs_to :employee, foreign_key: { to_table: :users }, type: :uuid
      t.belongs_to :cooperative, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
