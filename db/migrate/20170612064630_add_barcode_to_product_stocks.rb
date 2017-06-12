class AddBarcodeToProductStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :product_stocks, :barcode, :string
  end
end
