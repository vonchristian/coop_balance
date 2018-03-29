class RemoveCooperativeFromStoreFronts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :store_fronts, :cooperative, foreign_key: true, type: :uuid
  end
end
