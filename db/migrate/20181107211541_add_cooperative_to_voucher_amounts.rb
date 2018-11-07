class AddCooperativeToVoucherAmounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :voucher_amounts, :cooperative, foreign_key: true, type: :uuid
  end
end
