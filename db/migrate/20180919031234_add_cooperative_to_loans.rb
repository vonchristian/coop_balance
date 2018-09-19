class AddCooperativeToLoans < ActiveRecord::Migration[5.2]
  def change
    add_reference :loans, :cooperative, foreign_key: true, type: :uuid
  end
end
