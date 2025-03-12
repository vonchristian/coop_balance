class AddOfficeToSavingsAccountApplications < ActiveRecord::Migration[6.0]
  def change
    add_reference :savings_account_applications, :office, foreign_key: true, type: :uuid
  end
end
