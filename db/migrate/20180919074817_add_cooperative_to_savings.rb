class AddCooperativeToSavings < ActiveRecord::Migration[5.2]
  def change
    add_reference :savings, :cooperative, foreign_key: true, type: :uuid
  end
end
