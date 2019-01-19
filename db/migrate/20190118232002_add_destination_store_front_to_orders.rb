class AddDestinationStoreFrontToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :destination_store_front, foreign_key: { to_table: :store_fronts }, type: :uuid
  end
end
