class AddPreviousEntryToEntries < ActiveRecord::Migration[5.2]
  def change
    add_reference :entries, :previous_entry, foreign_key: { to_table: :entries }, type: :uuid
    add_column :entries, :previous_entry_hash, :string
    add_column :entries, :encrypted_hash, :string

    add_index :entries, :previous_entry_hash, unique: true
    add_index :entries, :encrypted_hash, unique: true

  end
end
