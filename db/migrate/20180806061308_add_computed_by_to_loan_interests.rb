class AddComputedByToLoanInterests < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_interests, :computed_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
