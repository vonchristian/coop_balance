class RemoveBarcodesFromLineItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :line_items, :barcodes, :string, array: true, default: '{}'
    remove_column :line_items, :barcode, :string
  end
end
