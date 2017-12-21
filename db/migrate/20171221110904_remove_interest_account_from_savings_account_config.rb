class RemoveInterestAccountFromSavingsAccountConfig < ActiveRecord::Migration[5.2]
  def change
    remove_reference :savings_account_configs, :interest_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
