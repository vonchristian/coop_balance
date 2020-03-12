class AddShowSubCategoriesToLevelTwoAccountCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :level_two_account_categories, :show_sub_categories, :boolean, default: true
  end
end
