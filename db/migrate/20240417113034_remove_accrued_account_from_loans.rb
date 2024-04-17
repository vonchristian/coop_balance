class RemoveAccruedAccountFromLoans < ActiveRecord::Migration[7.1]
  def change
    remove_reference :loans, :accrued_income_account, null: false, foreign_key: { to_table: :accounts }
    remove_reference :interest_configs, :accrued_income_account, null: false, foreign_key: { to_table: :accounts }
  end
end
