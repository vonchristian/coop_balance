class AddCommercialDocumentToLoanCharges < ActiveRecord::Migration[5.1]
  def change
    add_reference :loan_charges, :commercial_document, polymorphic: true, type: :uuid, index: { name: "index_commercial_document_on_loan_charges" }
  end
end
