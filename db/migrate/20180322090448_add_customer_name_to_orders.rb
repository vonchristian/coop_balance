class AddCustomerNameToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :commercial_document_name, :string
  end
end
