class AddAccountToLoans < ActiveRecord::Migration[6.0]
  def change
    add_reference :loans, :receivable_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :loans, :interest_revenue_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :loans, :penalty_revenue_account, foreign_key: { to_table: :accounts }, type: :uuid 
  end
end
