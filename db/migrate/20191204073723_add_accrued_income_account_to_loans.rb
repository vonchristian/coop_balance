class AddAccruedIncomeAccountToLoans < ActiveRecord::Migration[6.0]
  def change
    add_reference :loans, :accrued_income_account, foreign_key: { to_table: :accounts }, type: :uuid 
  end
end
