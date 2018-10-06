class AddOfficeToLoanApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_applications, :office, foreign_key: true, type: :uuid
  end
end
