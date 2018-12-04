class IncreateVoucherAmountsLimit < ActiveRecord::Migration[5.2]
  def change
    change_column :voucher_amounts, :amount_cents, :integer, limit: 8
  end
end
