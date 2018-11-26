class AddAmortizationTypeToInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :interest_configs, :amortization_type, :integer, default: 0
    add_index :interest_configs, :amortization_type
  end
end
