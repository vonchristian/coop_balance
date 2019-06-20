class AddCategoryTypeToAccountCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :account_categories, :category_type, :integer
    add_index :account_categories, :category_type
  end
end
