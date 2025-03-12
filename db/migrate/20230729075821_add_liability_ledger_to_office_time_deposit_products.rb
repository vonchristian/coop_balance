class AddLiabilityLedgerToOfficeTimeDepositProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :office_time_deposit_products, :liability_ledger, foreign_key: { to_table: :ledgers }, type: :uuid
    add_reference :office_time_deposit_products, :interest_expense_ledger, foreign_key: { to_table: :ledgers }, type: :uuid, index: { name: 'rsadsad' }
    add_reference :office_time_deposit_products, :break_contract_revenue_ledger, foreign_key: { to_table: :ledgers }, type: :uuid, index: { name: 'indedasd' }
  end
end
