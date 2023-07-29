class AddReceivableLedgerToLoanAgingGroups < ActiveRecord::Migration[6.1]
  def change
    add_reference :loan_aging_groups, :receivable_ledger, foreign_key: { to_table: :ledgers }, type: :uuid
  end
end
