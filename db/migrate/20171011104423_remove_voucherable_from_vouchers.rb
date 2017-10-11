class RemoveVoucherableFromVouchers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :vouchers, :voucherable, polymorphic: true
    remove_reference :vouchers, :payee, polymorphic: true
  end
end
