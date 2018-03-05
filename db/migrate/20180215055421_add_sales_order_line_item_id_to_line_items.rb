class AddSalesOrderLineItemIdToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :sales_order_line_item, type: :uuid
    add_reference :line_items, :purchase_order_line_item, type: :uuid
  end
end
