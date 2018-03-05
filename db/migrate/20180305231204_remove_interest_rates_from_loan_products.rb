class RemoveInterestRatesFromLoanProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :loan_products, :interest_rate, :decimal
    remove_column :loan_products, :penalty_rate, :decimal
  end
end
