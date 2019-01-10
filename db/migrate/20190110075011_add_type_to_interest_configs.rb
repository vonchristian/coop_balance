class AddTypeToInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :interest_configs, :type, :string
    add_index :interest_configs, :type
  end
end
