class AddCategoryToCharges < ActiveRecord::Migration[5.1]
  def change
    add_column :charges, :category, :integer
    add_index :charges, :category
  end
end
