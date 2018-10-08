class RemoveReceiptableFromOfficialReceipts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :official_receipts, :receiptable, polymorhic: true, type: :uuid
  end
end
