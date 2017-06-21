class AddLoanStatusToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :loan_status, :integer, default: 0
  end
end
