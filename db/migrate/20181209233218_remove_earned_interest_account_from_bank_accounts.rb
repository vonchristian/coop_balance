class RemoveEarnedInterestAccountFromBankAccounts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :bank_accounts, :earned_interest_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
