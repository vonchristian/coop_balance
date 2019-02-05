class AddApprovedAtToLoanApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_applications, :approved_at, :datetime
  end
end
