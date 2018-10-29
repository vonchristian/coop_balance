class AddChargeTypeToLoanProductCharges < ActiveRecord::Migration[5.2]
  def change
    add_column :loan_product_charges, :charge_type, :integer
  end
end
