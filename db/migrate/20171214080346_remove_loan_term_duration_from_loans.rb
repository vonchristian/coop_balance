class RemoveLoanTermDurationFromLoans < ActiveRecord::Migration[5.2]
  def change
    remove_column :loans, :loan_term_duration, :integer
  end
end
