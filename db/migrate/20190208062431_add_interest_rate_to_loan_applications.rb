class AddInterestRateToLoanApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_applications, :annual_interest_rate, :decimal
  end
end
