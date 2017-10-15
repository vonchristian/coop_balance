class AddDescriptionToLoanApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :loan_approvals, :description, :string
  end
end
