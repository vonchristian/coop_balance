class AddTermToTimeDeposits < ActiveRecord::Migration[6.0]
  def change
    add_reference :time_deposits, :term, null: false, foreign_key: true, type: :uuid 
  end
end
