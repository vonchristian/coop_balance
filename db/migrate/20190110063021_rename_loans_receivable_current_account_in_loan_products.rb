class RenameLoansReceivableCurrentAccountInLoanProducts < ActiveRecord::Migration[5.2]
  def change
      rename_column :loan_products, :loans_receivable_current_account_id, :current_account_id

      rename_column :loan_products, :loans_receivable_past_due_account_id, :past_due_account_id
  end
end
