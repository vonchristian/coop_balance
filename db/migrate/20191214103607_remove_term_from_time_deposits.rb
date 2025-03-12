class RemoveTermFromTimeDeposits < ActiveRecord::Migration[6.0]
  def change
    remove_reference :time_deposits, :term, null: false, foreign_key: true, type: :uuid
  end
end
