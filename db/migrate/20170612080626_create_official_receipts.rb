class CreateOfficialReceipts < ActiveRecord::Migration[5.1]
  def change
    create_table :official_receipts, id: :uuid do |t|
      t.string :number, null: false
      t.references :receiptable, index: true, polymorphic: true, type: :uuid
      t.timestamps
    end
  end
end
