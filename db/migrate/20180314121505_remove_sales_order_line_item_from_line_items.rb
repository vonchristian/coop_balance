class RemoveSalesOrderLineItemFromLineItems < ActiveRecord::Migration[5.1]
  def change
  remove_reference :line_items, :sales_order_line_item, type: :uuid
  end
end
