class AddVoucherToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :voucher, foreign_key: true, type: :uuid
  end
end
