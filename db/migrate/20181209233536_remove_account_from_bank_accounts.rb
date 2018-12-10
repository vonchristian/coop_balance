class RemoveAccountFromBankAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :bank_accounts, :account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
