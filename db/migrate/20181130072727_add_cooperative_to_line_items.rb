class AddCooperativeToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :line_items, :cooperative, foreign_key: true, type: :uuid
  end
end
