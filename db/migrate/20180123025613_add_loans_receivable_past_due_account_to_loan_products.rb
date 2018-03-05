class AddLoansReceivablePastDueAccountToLoanProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :loan_products, :loans_receivable_past_due_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
