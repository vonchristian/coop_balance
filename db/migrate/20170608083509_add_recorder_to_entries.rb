class AddRecorderToEntries < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :recorder, foreign_key: { to_table: :users }, type: :uuid
  end
end
