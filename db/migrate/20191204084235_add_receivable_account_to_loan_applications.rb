class AddReceivableAccountToLoanApplications < ActiveRecord::Migration[6.0]
  def change
    add_reference :loan_applications, :receivable_account, foreign_key: { to_table: :accounts }, type: :uuid 
    add_reference :loan_applications, :interest_revenue_account, foreign_key: { to_table: :accounts }, type: :uuid 
  end
end
