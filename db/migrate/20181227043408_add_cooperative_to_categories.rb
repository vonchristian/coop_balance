class AddCooperativeToCategories < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :cooperative, foreign_key: true, type: :uuid
  end
end
