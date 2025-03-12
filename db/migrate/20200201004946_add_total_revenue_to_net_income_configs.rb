class AddTotalRevenueToNetIncomeConfigs < ActiveRecord::Migration[6.0]
  def change
    add_reference :net_income_configs, :total_revenue_account,  foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :net_income_configs, :total_expense_account,  foreign_key: { to_table: :accounts }, type: :uuid
  end
end
