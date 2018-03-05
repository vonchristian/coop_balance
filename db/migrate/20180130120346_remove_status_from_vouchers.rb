class RemoveStatusFromVouchers < ActiveRecord::Migration[5.1]
  def change
    remove_index :vouchers, :status
    remove_column :vouchers, :status, :integer
  end
end
