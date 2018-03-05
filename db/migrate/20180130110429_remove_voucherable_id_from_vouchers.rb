class RemoveVoucherableIdFromVouchers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :vouchers, :voucherable, polymorphic: true, type: :uuid
  end
end
