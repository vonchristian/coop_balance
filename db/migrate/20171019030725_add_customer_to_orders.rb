class AddCustomerToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :customer, polymorphic: true, type: :uuid
  end
end
