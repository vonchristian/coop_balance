class AddEntryTimeToEntries < ActiveRecord::Migration[6.0]
  def change
    add_column :entries, :entry_time, :datetime
  end
end
