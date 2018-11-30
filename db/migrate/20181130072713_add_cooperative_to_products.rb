class AddCooperativeToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :cooperative, foreign_key: true, type: :uuid
  end
end
