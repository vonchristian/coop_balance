class RemoveMemberFromTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    remove_reference :time_deposits, :member, foreign_key: true
  end
end
