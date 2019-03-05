class AddCancelledAtToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :cancelled_at, :datetime
  end
end
