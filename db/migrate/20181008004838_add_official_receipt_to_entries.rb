class AddOfficialReceiptToEntries < ActiveRecord::Migration[5.2]
  def change
    add_reference :entries, :official_receipt, foreign_key: true, type: :uuid
  end
end
