class AddApprovedToLoanApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_applications, :approved, :boolean, default: false
  end
end
