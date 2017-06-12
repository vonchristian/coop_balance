class AddPayTypeToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :payment_type, :integer
  end
end
