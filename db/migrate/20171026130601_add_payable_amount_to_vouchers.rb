class AddPayableAmountToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_column :vouchers, :payable_amount, :decimal
  end
end
