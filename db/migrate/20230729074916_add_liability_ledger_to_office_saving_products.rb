class AddLiabilityLedgerToOfficeSavingProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :office_saving_products, :liability_ledger, foreign_key: { to_table: :ledgers }, type: :uuid
    add_reference :office_saving_products, :interest_expense_ledger, foreign_key: { to_table: :ledgers }, type: :uuid
  end
end
