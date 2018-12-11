class AddBarangayToTimeDeposits < ActiveRecord::Migration[5.2]
  def change
    add_reference :time_deposits, :barangay, foreign_key: true, type: :uuid
  end
end
