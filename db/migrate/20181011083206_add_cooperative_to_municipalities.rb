class AddCooperativeToMunicipalities < ActiveRecord::Migration[5.2]
  def change
    add_reference :municipalities, :cooperative, foreign_key: true, type: :uuid
  end
end
