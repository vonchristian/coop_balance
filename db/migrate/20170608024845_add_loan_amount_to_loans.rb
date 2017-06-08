class AddLoanAmountToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :loan_amount, :decimal
  end
end
