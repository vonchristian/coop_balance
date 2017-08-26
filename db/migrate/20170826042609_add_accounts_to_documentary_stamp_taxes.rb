class AddAccountsToDocumentaryStampTaxes < ActiveRecord::Migration[5.1]
  def change
    add_reference :documentary_stamp_taxes, :credit_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :documentary_stamp_taxes, :debit_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
