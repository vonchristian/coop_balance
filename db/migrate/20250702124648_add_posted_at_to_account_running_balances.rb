class AddPostedAtToAccountRunningBalances < ActiveRecord::Migration[8.0]
  def change
    add_column :account_running_balances, :posted_at, :datetime
    add_index :account_running_balances, :posted_at
  end
end
