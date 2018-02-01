class AddReferencedLineItemToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :line_items, :referenced_line_item, foreign_key: { to_table: :line_items }, type: :uuid
  end
end
