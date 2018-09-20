class AddCalculationTypeToInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :interest_configs, :calculation_type, :integer
    add_column :interest_configs, :prededuction_type, :integer

    add_index :interest_configs, :calculation_type
    add_index :interest_configs, :prededuction_type
    add_column :interest_configs, :prededucted_rate, :decimal
  end
end
