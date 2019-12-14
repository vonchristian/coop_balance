class AddNumberOfDaysToLoanApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :loan_applications, :number_of_days, :integer
  end
end
