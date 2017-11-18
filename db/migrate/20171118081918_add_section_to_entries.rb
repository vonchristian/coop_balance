class AddSectionToEntries < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :section, foreign_key: true, type: :uuid
  end
end
