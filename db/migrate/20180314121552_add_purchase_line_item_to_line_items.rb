class AddPurchaseLineItemToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :purchase_line_item, type: :uuid, index: true
  end
end
