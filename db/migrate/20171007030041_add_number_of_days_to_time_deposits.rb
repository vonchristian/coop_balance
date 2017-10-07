class AddNumberOfDaysToTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposits, :number_of_days, :integer
  end
end
