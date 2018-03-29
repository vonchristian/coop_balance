class AddStoreFrontToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :store_front, foreign_key: true, type: :uuid
  end
end
