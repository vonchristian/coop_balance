class AddCashInVaultAccountToOffices < ActiveRecord::Migration[5.1]
  def change
    add_reference :offices, :cash_in_vault_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
