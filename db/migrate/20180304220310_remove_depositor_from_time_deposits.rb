class RemoveDepositorFromTimeDeposits < ActiveRecord::Migration[5.2]
  def change
    remove_reference :time_deposits, :depositor, polymorphic: true
  end
end
