class AddIocAccountToNetIncomeConfigs < ActiveRecord::Migration[6.0]
  def change
    add_reference :net_income_configs, :interest_on_capital_account, type: :uuid,  foreign_key: { to_table: :accounts }
  end
end
