class AddDescriptionToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :description, :string
  end
end
