class RemoveVoucherFromEntries < ActiveRecord::Migration[5.2]
  def change
    remove_reference :entries, :voucher, foreign_key: true, type: :uuid
  end
end
