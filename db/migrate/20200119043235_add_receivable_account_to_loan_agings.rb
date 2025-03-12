class AddReceivableAccountToLoanAgings < ActiveRecord::Migration[6.0]
  def change
    add_reference :loan_agings, :receivable_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
