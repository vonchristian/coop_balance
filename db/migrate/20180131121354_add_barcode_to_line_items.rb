class AddBarcodeToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :barcode, :string
  end
end
