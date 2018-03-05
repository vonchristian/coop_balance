class RemoveInterestAccountFromLoanProducts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :loan_products, :interest_account, foreign_key: { to_table: :accounts }, type: :uuid
    remove_reference :loan_products, :interest_receivable_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
