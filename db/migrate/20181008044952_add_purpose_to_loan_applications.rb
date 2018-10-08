class AddPurposeToLoanApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_applications, :purpose, :text
  end
end
