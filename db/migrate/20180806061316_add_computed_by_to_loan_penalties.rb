class AddComputedByToLoanPenalties < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_penalties, :computed_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
