class DropMerchants < ActiveRecord::Migration[7.0]
  def up
    drop_table :merchants
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
