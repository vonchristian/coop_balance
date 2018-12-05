class AddRateTypeToInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :interest_configs, :rate_type, :integer
    add_index :interest_configs, :rate_type
  end
end
