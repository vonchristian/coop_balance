class DropTableAccountCategories < ActiveRecord::Migration[6.0]
  def up
    drop_table :account_categories
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
