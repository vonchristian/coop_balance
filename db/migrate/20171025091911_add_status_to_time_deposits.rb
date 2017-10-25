class AddStatusToTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposits, :status, :integer
    add_index :time_deposits, :status
  end
end
