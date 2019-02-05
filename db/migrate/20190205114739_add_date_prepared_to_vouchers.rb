class AddDatePreparedToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :date_prepared, :datetime
    add_column :vouchers, :disbursement_date, :datetime
  end
end
