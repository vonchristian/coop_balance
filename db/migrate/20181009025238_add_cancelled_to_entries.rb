class AddCancelledToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :cancelled, :boolean, default: false
    add_column :entries, :cancelled_at, :datetime
    add_reference :entries, :cancelled_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
