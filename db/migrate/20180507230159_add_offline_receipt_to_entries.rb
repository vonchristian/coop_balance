class AddOfflineReceiptToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :offline_receipt, :boolean, default: false
  end
end
