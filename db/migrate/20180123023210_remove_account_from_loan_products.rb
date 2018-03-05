class RemoveAccountFromLoanProducts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :loan_products, :account, foreign_key: true, type: :uuid
  end
end
