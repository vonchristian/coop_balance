class AddLiabilityAccountToSavingsApplications < ActiveRecord::Migration[6.0]
  def change
    add_reference :savings_account_applications, :liability_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
