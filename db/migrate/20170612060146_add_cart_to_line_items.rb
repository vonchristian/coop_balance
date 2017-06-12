class AddCartToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :cart, foreign_key: true, type: :uuid
  end
end
