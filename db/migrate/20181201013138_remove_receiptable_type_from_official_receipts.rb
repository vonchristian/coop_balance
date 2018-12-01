class RemoveReceiptableTypeFromOfficialReceipts < ActiveRecord::Migration[5.2]
  def change
    remove_column :official_receipts, :receiptable_type, :string
  end
end
