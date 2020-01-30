class RenameNetIncomeToNetSurplusOnNetIncomeConfigs < ActiveRecord::Migration[6.0]
  def change
    rename_column :net_income_configs, :net_income_account_id, :net_surplus_account_id
  end
end
