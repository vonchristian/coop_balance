class AddQuantityToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :quantity, :decimal
  end
end
