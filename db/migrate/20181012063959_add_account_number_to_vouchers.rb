class AddAccountNumberToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :account_number, :string
    add_index :vouchers, :account_number, unique: true
  end
end
