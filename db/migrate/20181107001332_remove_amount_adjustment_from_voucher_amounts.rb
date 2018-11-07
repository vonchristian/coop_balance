class RemoveAmountAdjustmentFromVoucherAmounts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :voucher_amounts, :amount_adjustment, foreign_key: true, type: :uuid
  end
end
