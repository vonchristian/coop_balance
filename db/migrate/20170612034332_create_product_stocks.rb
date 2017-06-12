class CreateProductStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :product_stocks, id: :uuid do |t|
      t.decimal :unit_cost
      t.decimal :total_cost
      t.belongs_to :product, foreign_key: true, type: :uuid
      t.belongs_to :supplier, foreign_key: true, type: :uuid
      t.datetime :date

      t.timestamps
    end
  end
end
