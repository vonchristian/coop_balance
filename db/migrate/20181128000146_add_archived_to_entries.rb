class AddArchivedToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :archived, :boolean, default: false
  end
end
