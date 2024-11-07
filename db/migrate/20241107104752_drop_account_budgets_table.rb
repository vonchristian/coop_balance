class DropAccountBudgetsTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :account_budgets, if_exists: true
  end
end
