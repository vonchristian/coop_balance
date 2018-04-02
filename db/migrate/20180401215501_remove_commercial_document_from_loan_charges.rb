class RemoveCommercialDocumentFromLoanCharges < ActiveRecord::Migration[5.2]
  def change
    remove_reference :loan_charges, :chargeable, polymorphic: true, type: :uuid
  end
end
