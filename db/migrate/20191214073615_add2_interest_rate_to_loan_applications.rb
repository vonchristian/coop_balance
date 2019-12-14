class Add2InterestRateToLoanApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :loan_applications, :interest_rate, :decimal, default: 0
  end
end
