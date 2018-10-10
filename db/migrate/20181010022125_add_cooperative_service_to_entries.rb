class AddCooperativeServiceToEntries < ActiveRecord::Migration[5.2]
  def change
    add_reference :entries, :cooperative_service, foreign_key: true, type: :uuid
  end
end
