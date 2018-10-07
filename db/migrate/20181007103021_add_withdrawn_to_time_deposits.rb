class AddWithdrawnToTimeDeposits < ActiveRecord::Migration[5.2]
  def change
    add_column :time_deposits, :withdrawn, :boolean, default: false
  end
end
