class AddCooperativeToRegistries < ActiveRecord::Migration[5.2]
  def change
    add_reference :registries, :cooperative, foreign_key: true, type: :uuid
  end
end
