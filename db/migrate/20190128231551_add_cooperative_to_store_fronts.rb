class AddCooperativeToStoreFronts < ActiveRecord::Migration[5.2]
  def change
    add_reference :store_fronts, :cooperative, foreign_key: true, type: :uuid 
  end
end
