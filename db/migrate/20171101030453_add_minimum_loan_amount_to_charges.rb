class AddMinimumLoanAmountToCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :minimum_loan_amount, :decimal
    add_column :charges, :maximum_loan_amount, :decimal
  end
end
