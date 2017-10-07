class AddDepositorNameToTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposits, :depositor_name, :string
  end
end
