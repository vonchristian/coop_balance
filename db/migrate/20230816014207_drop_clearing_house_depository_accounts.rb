class DropClearingHouseDepositoryAccounts < ActiveRecord::Migration[7.0]
  def up
    drop_table :clearing_house_depository_accounts
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
