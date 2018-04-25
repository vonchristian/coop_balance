class RemoveLoanTermFromLoans < ActiveRecord::Migration[5.2]
  def change
    remove_column :loans, :loan_term, :integer
  end
end
