class AddInterestRebateAccountToInterestConfigs < ActiveRecord::Migration[5.1]
  def change
    add_reference :interest_configs, :interest_rebate_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
