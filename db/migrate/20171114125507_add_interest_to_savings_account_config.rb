class AddInterestToSavingsAccountConfig < ActiveRecord::Migration[5.1]
  def change
    add_reference :savings_account_configs, :interest_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
