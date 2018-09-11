class AddAnnualRateToInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :interest_configs, :annual_rate, :decimal
  end
end
