class AddBusinessNameToSuppliers < ActiveRecord::Migration[5.1]
  def change
    add_column :suppliers, :business_name, :string
    add_column :suppliers, :address, :string
  end
end
