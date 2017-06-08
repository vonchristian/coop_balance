class AddLoanTermToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :duration, :decimal
    add_column :loans, :loan_term_duration, :integer
  end
end
