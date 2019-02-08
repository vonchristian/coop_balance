class AddAdjustableInterestRateToLoanProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_products, :adjustable_interest_rate, :boolean, default: false
  end
end
