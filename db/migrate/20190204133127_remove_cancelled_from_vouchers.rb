class RemoveCancelledFromVouchers < ActiveRecord::Migration[5.2]
  def change
    remove_column :vouchers, :cancelled, :boolean
  end
end
