class CreateSalesPurchaseLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_purchase_line_items, id: :uuid do |t|
      t.belongs_to :sales_line_item, foreign_key: { to_table: :line_items }, type: :uuid
      t.belongs_to :purchase_line_item, foreign_key: { to_table: :line_items }, type: :uuid
      t.decimal :quantity
      t.timestamps
    end
  end
end
