class AddMaturityDateToTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposits, :maturity_date, :datetime
  end
end
