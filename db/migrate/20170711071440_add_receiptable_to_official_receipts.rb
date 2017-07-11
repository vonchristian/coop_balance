class AddReceiptableToOfficialReceipts < ActiveRecord::Migration[5.1]
  def change
    add_reference :official_receipts, :receiptable, index: true, polymorphic: true, type: :uuid
  end
end
