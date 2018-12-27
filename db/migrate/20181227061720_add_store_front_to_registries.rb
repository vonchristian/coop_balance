class AddStoreFrontToRegistries < ActiveRecord::Migration[5.2]
  def change
    add_reference :registries, :store_front, foreign_key: true, type: :uuid
  end
end
