class AddVoucherableFromVouchers < ActiveRecord::Migration[5.1]
  def change
    add_reference :vouchers, :voucherable, polymorphic: true, type: :uuid
    add_reference :vouchers, :payee, polymorphic: true, type: :uuid
  end
end
