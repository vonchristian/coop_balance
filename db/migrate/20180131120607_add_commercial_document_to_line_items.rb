class AddCommercialDocumentToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :commercial_document, polymorphic: true, type: :uuid, index: { name: "index_commercial_document_on_line_items" }
  end
end
