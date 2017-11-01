class AddDependsOnLoanAmountToCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :depends_on_loan_amount, :boolean, default: false
  end
end
