class RemoveAnnualRateFromInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    remove_column :interest_configs, :annual_rate, :decimal
  end
end
