class DropUtilityBillCategories < ActiveRecord::Migration[7.0]
  def up
    drop_table :utility_bill_categories
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
