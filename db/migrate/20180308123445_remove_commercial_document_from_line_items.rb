class RemoveCommercialDocumentFromLineItems < ActiveRecord::Migration[5.1]
  def change
    remove_reference :line_items, :commercial_document, polymorphic: true, type: :uuid
  end
end
