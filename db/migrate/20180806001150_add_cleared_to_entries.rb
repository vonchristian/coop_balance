class AddClearedToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :cleared, :boolean, default: :false
    add_column :entries, :cleared_at, :datetime
  end
end
