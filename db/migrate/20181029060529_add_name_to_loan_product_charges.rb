class AddNameToLoanProductCharges < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_product_charges, :name, :string
    add_column :loan_product_charges, :amount, :decimal
    add_column :loan_product_charges, :rate, :decimal
  end
end
