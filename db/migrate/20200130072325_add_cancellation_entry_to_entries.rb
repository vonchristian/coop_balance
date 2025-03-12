class AddCancellationEntryToEntries < ActiveRecord::Migration[6.0]
  def change
    add_reference :entries, :cancellation_entry, foreign_key: { to_table: :entries }, type: :uuid
  end
end
