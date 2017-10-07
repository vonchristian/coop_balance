class AddDateDepositedToTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposits, :date_deposited, :datetime
  end
end
