class AddOrganizationToLoanApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :loan_applications, :organization, foreign_key: true, type: :uuid
  end
end
