class RemoveDateDepositedFromTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    remove_column :time_deposits, :date_deposited, :datetime
    remove_column :time_deposits, :maturity_date, :datetime
    remove_column :time_deposits, :number_of_days, :integer
  end
end
