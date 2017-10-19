class RemoveMemberFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :orders, :member, foreign_key: true
  end
end
