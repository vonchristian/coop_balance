class AddRecorderToVoucherAmounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :voucher_amounts, :recorder, foreign_key: { to_table: :users }, type: :uuid
  end
end
