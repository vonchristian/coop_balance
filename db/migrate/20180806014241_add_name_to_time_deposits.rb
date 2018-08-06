class AddNameToTimeDeposits < ActiveRecord::Migration[5.2]
  def change
    add_column :time_deposits, :depositor_name, :string
  end
end
