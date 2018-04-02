class AddChargeToLoanCharges < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_charges, :charge, foreign_key: true, type: :uuid
  end
end
