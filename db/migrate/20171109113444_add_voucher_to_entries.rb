class AddVoucherToEntries < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :voucher, foreign_key: true, type: :uuid
  end
end
