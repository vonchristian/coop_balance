class RemoveCooperativeServiceIdFromAmounts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :amounts, :cooperative_service, foreign_key: true
  end
end
