class AddClearedByToEntries < ActiveRecord::Migration[5.2]
  def change
    add_reference :entries, :cleared_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
