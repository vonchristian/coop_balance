class AddCreditToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :credit, :boolean, default: :false
  end
end
