class RemoveDepositorFromTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    remove_reference :time_deposits, :depositor, polymorphic: true
  end
end
