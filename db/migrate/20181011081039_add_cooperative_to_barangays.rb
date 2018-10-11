class AddCooperativeToBarangays < ActiveRecord::Migration[5.2]
  def change
    add_reference :barangays, :cooperative, foreign_key: true, type: :uuid
  end
end
