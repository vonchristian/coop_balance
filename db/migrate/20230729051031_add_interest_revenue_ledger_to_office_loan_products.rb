class AddInterestRevenueLedgerToOfficeLoanProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :office_loan_products, :interest_revenue_ledger, foreign_key: { to_table: :ledgers }, type: :uuid
    add_reference :office_loan_products, :penalty_revenue_ledger, foreign_key: { to_table: :ledgers }, type: :uuid
  end
end
