class AddSalesLineItemToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :sales_line_item, index: true, type: :uuid
  end
end
