class RemoveOrderFromOfficialReceipts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :official_receipts, :order, foreign_key: true
  end
end
