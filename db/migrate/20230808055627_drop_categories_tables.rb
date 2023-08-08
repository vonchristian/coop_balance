class DropCategoriesTables < ActiveRecord::Migration[7.0]
  def up
    remove_column :office_saving_products, :closing_account_category_id, if_exists: true
    drop_table :level_one_account_categories
    drop_table :level_two_account_categories
    drop_table :level_three_account_categories
    drop_table :level_four_account_categories
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
