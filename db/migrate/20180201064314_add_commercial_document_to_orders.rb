class AddCommercialDocumentToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :commercial_document, polymorphic: true, type: :uuid, index: { name: "index_commercial_document_on_orders" }
  end
end
