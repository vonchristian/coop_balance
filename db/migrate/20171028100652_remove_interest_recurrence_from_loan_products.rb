class RemoveInterestRecurrenceFromLoanProducts < ActiveRecord::Migration[5.1]
  def change
    remove_index :loan_products, :interest_recurrence
    remove_column :loan_products, :interest_recurrence, :integer
  end
end
