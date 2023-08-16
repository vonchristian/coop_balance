class DropAutomatedClearingHouses < ActiveRecord::Migration[7.0]
  def up
    drop_table :automated_clearing_houses
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
