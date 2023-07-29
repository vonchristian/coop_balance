class AddLedgerToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_reference :accounts, :ledger, foreign_key: true, type: :uuid
  end
end
