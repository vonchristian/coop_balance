class AddCommercialDocumentToAmounts < ActiveRecord::Migration[5.1]
  def change
    add_reference :amounts, :commercial_document, polymorphic: true, type: :uuid, index: { name: 'index_amounts_on_commercial_document' }
  end
end
