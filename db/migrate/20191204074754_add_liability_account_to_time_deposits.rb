class AddLiabilityAccountToTimeDeposits < ActiveRecord::Migration[6.0]
  def change
    add_reference :time_deposits, :liability_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :time_deposits, :interest_expense_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :time_deposits, :break_contract_account, foreign_key: { to_table: :accounts }, type: :uuid 

  end
end
