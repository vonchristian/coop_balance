class AddDisburserToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_reference :vouchers, :disburser, foreign_key: { to_table: :users }, type: :uuid
  end
end
