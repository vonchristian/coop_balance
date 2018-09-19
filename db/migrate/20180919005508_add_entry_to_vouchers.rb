class AddEntryToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_reference :vouchers, :entry, foreign_key: true, type: :uuid
  end
end
