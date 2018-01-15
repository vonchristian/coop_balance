class AddInterestReceivableAccountToLoanProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_products, :interest_receivable_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
