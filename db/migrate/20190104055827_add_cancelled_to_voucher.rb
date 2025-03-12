class AddCancelledToVoucher < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :cancelled, :boolean, default: false
  end
end
