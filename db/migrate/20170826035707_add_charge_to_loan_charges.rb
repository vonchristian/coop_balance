class AddChargeToLoanCharges < ActiveRecord::Migration[5.1]
  def change
    add_reference :loan_charges, :chargeable, polymorphic: true, type: :uuid
  end
end
