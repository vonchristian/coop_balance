class AddCompleteAddressToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :complete_address, :string
  end
end
