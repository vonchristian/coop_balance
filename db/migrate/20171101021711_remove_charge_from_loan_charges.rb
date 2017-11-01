class RemoveChargeFromLoanCharges < ActiveRecord::Migration[5.1]
  def change
    remove_reference :loan_charges, :charge, foreign_key: true
  end
end
