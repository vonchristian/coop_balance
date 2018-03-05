class RemoveLineItemableFromLineItems < ActiveRecord::Migration[5.1]
  def change
    remove_reference :line_items, :line_itemable, polymorphic: true, type: :uuid
  end
end
