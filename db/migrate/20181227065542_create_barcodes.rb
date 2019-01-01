class CreateBarcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :barcodes, id: :uuid do |t|
      t.string :code
      t.references :barcodeable, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
