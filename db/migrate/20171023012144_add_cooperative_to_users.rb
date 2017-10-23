class AddCooperativeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :cooperative, foreign_key: true, type: :uuid
  end
end
