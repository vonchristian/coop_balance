class DropTableAccountSubCategories < ActiveRecord::Migration[6.0]
  def up
    drop_table :account_sub_categories
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
