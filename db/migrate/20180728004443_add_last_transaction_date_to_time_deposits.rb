class AddLastTransactionDateToTimeDeposits < ActiveRecord::Migration[5.2]
  def change
    add_column :time_deposits, :last_transaction_date, :datetime
  end
end
