class AddCooperativeToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_reference :programs, :cooperative, foreign_key: true, type: :uuid
  end
end
