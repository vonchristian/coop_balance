class AddInterestRateToLoanProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :loan_products, :interest_rate, :decimal
  end
end
