class RemoveInterestRateFromLoanProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :loan_products, :interest_rate, :string
  end
end
