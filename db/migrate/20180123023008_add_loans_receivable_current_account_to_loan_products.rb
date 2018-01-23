class AddLoansReceivableCurrentAccountToLoanProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_products, :loans_receivable_current_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
