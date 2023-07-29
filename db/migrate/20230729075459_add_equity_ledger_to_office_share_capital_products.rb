class AddEquityLedgerToOfficeShareCapitalProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :office_share_capital_products, :equity_ledger, foreign_key: { to_table: :ledgers }, type: :uuid
  end
end
