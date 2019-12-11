class AddLevelThreeAccountCategoryToLevelTwoAccountCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :level_two_account_categories, :level_three_account_category, foreign_key: true, type: :uuid, index: { name: 'index_l3_account_category_on_l2_account_categories' }
  end
end
