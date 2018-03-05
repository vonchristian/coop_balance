class AddMembershipToTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    add_reference :time_deposits, :membership, foreign_key: true, type: :uuid
  end
end
