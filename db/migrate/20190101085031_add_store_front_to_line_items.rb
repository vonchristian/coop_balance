class AddStoreFrontToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :line_items, :store_front, foreign_key: true, type: :uuid
  end
end
