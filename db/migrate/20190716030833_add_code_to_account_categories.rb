class AddCodeToAccountCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :account_categories, :code, :string
  end
end
