class AddRestructuredLoanAccountToLoanProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_products, :restructured_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
