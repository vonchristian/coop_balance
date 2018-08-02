class AddTokenToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :token, :string
    add_index :vouchers, :token
  end
end
