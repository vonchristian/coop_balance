class AddTypeToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_column :vouchers, :type, :string
    add_index :vouchers, :type
  end
end
