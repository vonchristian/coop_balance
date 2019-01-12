class AddForwardedToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :forwarded, :boolean, default: false, null: false
  end
end
