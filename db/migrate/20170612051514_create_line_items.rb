class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :line_items, id: :uuid do |t|
      t.belongs_to :product, foreign_key: true, type: :uuid
      t.belongs_to :product_stock, foreign_key: true, type: :uuid
      t.belongs_to :order, foreign_key: true, type: :uuid
      t.belongs_to :cart, foreign_key: true, type: :uuid
      t.references :line_itemable, polymorphic: true, index: true, type: :uuid
      t.decimal :unit_cost
      t.decimal :total_cost
      t.decimal :quantity
      t.datetime :date

      t.timestamps
    end
  end
end
