class AddPreparerToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_reference :vouchers, :preparer, foreign_key: { to_table: :users }, type: :uuid
  end
end
