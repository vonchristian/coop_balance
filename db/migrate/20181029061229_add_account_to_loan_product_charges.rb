class AddAccountToLoanProductCharges < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_product_charges, :account, foreign_key: true, type: :uuid
  end
end
