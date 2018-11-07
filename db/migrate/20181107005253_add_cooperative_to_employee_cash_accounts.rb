class AddCooperativeToEmployeeCashAccounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :employee_cash_accounts, :cooperative, foreign_key: true, type: :uuid
  end
end
