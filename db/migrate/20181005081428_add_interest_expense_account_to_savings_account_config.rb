class AddInterestExpenseAccountToSavingsAccountConfig < ActiveRecord::Migration[5.2]
  def change
    add_reference :savings_account_configs, :interest_expense_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
