class RemoveInterestRecurrenceFromTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :time_deposit_products, :interest_recurrence, :integer
  end
end