class RemoveDepositorNameFromTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    remove_column :time_deposits, :depositor_name, :string, type: :uuid
  end
end
