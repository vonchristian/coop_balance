class AddEarnedInterestAccountToBankAccounts < ActiveRecord::Migration[5.1]
  def change
    add_reference :bank_accounts, :earned_interest_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
