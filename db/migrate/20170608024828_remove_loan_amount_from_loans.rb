class RemoveLoanAmountFromLoans < ActiveRecord::Migration[5.1]
  def change
    remove_column :loans, :loan_amount, :decimal
  end
end
