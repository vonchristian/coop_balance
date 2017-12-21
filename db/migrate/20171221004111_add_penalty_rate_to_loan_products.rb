class AddPenaltyRateToLoanProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_products, :penalty_rate, :decimal
  end
end
