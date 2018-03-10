class AddInterestExpenseAccountIdToTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :time_deposit_products, :break_contract_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :time_deposit_products, :interest_expense_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_column :time_deposit_products, :break_contract_fee, :decimal
  end
end
