class RemoveBarcodeableFromBarcodes < ActiveRecord::Migration[5.2]
  def change
    remove_reference :barcodes, :barcodeable, polymorphic: true, type: :uuid
  end
end
