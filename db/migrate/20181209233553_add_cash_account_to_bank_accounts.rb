class AddCashAccountToBankAccounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :bank_accounts, :cash_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
