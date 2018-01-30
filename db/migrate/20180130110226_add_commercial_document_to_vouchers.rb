class AddCommercialDocumentToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_reference :vouchers, :commercial_document, polymorphic: true, type: :uuid, index: { name: "index_commercial_document_on_vouchers" }
  end
end
