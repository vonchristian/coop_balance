class AddOfficeToEntries < ActiveRecord::Migration[5.2]
  def change
    add_reference :entries, :office, foreign_key: true, type: :uuid
    add_reference :entries, :cooperative, foreign_key: true, type: :uuid
  end
end
