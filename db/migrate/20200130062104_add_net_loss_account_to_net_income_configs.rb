class AddNetLossAccountToNetIncomeConfigs < ActiveRecord::Migration[6.0]
  def change
    add_reference :net_income_configs, :net_loss_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
