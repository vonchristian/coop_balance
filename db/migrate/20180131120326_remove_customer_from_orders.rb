class RemoveCustomerFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :orders, :customer, polymorphic: true, type: :uuid
  end
end
