class AddUserIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :user, foreign_key: true, type: :uuid
  end
end
