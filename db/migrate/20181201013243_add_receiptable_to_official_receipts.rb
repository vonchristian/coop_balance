class AddReceiptableToOfficialReceipts < ActiveRecord::Migration[5.2]
  def change
    add_reference :official_receipts, :receiptable, polymorphic: true, type: :uuid
  end
end
