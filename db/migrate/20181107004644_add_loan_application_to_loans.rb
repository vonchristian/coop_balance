class AddLoanApplicationToLoans < ActiveRecord::Migration[5.2]
  def change
    add_reference :loans, :loan_application, foreign_key: true, type: :uuid
  end
end
