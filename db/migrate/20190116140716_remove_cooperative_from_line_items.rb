class RemoveCooperativeFromLineItems < ActiveRecord::Migration[5.2]
  def change
    remove_reference :line_items, :cooperative, foreign_key: true, type: :uuid
    remove_reference :line_items, :store_front, foreign_key: true, type: :uuid
    remove_column :line_items, :forwarded, :boolean
    remove_column :line_items, :date, :datetime
  end
end
