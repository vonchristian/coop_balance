class RemoveChargeFromLoanProductCharges < ActiveRecord::Migration[5.2]
  def change
    remove_reference :loan_product_charges, :charge, foreign_key: true, type: :uuid
  end
end
