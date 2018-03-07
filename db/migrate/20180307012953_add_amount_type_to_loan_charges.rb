class AddAmountTypeToLoanCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :loan_charges, :amount_type, :integer
    add_index :loan_charges, :amount_type
  end
end
