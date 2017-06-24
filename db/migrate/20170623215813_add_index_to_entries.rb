class AddIndexToEntries < ActiveRecord::Migration[5.1]
  def change
    add_index :entries, :entry_date
  end
end
