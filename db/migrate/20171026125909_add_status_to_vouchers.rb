class AddStatusToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_column :vouchers, :status, :integer
    add_index :vouchers, :status
  end
end
