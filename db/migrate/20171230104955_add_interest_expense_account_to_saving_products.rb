class AddInterestExpenseAccountToSavingProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :saving_products, :interest_expense_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
