class AddLineItemableToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :line_itemable, polymorphic: true, type: :uuid
  end
end
