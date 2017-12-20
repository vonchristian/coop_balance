class AddInterestAccountToLoanProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_products, :interest_account, foreign_key: { to_table: :accounts }, type: :uuid
    add_reference :loan_products, :penalty_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
