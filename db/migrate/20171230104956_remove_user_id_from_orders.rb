class RemoveUserIdFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_reference :orders, :user, foreign_key: true, type: :uuid
  end
end
