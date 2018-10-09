class RemoveClearedFromEntries < ActiveRecord::Migration[5.2]
  def change
    remove_column :entries, :cleared, :boolean
    remove_column :entries, :cleared_at, :datetime
    remove_reference :entries, :cleared_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
