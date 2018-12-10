class AddOfficeToBankAccounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :bank_accounts, :office, foreign_key: true, type: :uuid
  end
end
