class AddCategoryToProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :category, foreign_key: true, type: :uuid
  end
end
