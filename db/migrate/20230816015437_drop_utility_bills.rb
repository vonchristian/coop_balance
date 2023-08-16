class DropUtilityBills < ActiveRecord::Migration[7.0]
  def up
    drop_table :utility_bills
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
