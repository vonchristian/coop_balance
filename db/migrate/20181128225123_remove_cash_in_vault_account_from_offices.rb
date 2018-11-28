class RemoveCashInVaultAccountFromOffices < ActiveRecord::Migration[5.2]
  def change
    remove_reference :offices, :cash_in_vault_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
