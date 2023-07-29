class AddLedgerToOfficeLoanProductAgingGroups < ActiveRecord::Migration[6.1]
  def change
    add_reference :office_loan_product_aging_groups, :ledger, foreign_key: true, type: :uuid
  end
end
