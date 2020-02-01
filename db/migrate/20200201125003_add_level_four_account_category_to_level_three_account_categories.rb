class AddLevelFourAccountCategoryToLevelThreeAccountCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :level_three_account_categories, :level_four_account_category, foreign_key: true, type: :uuid, index: { name: 'index_l4_account_category_on_l3_account_categories' }
  end
end
