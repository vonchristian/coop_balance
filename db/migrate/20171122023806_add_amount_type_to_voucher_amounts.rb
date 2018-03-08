class AddAmountTypeToVoucherAmounts < ActiveRecord::Migration[5.1]
  def change
    add_column :voucher_amounts, :amount_type, :integer, default: 0
    add_index :voucher_amounts, :amount_type
  end
end
