class AddInterestRateTypeToInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :interest_configs, :interest_type, :integer
    add_index :interest_configs, :interest_type
  end
end
