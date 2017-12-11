class AddCurrentToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :current, :boolean, default: :false
  end
end
