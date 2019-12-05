class RemovePreviousEntryFromEntries < ActiveRecord::Migration[6.0]
  def change
    remove_reference :entries, :previous_entry, null: false, foreign_key: { to_table: :entries }, type: :uuid 

    remove_column :entries, :encrypted_hash, :string

    remove_column :entries, :previous_entry_hash, :string
  end
end
