class AddCooperativeToSavingsAccountApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :savings_account_applications, :cooperative, foreign_key: true, type: :uuid
  end
end
