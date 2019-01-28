class AddCooperativeServiceToStoreFronts < ActiveRecord::Migration[5.2]
  def change
    add_reference :store_fronts, :cooperative_service, foreign_key: true, type: :uuid
  end
end
