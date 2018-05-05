class AddUnearnedToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :unearned, :boolean, default: false
  end
end
