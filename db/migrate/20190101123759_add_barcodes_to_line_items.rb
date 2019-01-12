class AddBarcodesToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :barcodes, :string, array: true, default: '{}'
  end
end
