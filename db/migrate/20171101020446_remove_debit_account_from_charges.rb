class RemoveDebitAccountFromCharges < ActiveRecord::Migration[5.1]
  def change
    remove_reference :charges, :debit_account, foreign_key: { to_table: :accounts }
    remove_reference :charges, :credit_account, foreign_key: { to_table: :accounts }
  end
end
