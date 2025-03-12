class AddInterestExpenseAccountOnSavings < ActiveRecord::Migration[6.0]
  def change
    add_reference :savings, :interest_expense_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
