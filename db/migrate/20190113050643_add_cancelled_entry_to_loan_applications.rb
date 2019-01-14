class AddCancelledEntryToLoanApplications < ActiveRecord::Migration[5.2]
  def change
  	add_column :loan_applications, :cancelled, :boolean, default: false
  end
end
