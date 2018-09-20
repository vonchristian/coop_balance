class AddAmountAdjustmentToVoucherAmounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :voucher_amounts, :amount_adjustment, foreign_key: true, type: :uuid
  end
end
