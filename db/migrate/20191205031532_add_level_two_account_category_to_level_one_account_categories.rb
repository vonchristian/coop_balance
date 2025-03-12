class AddLevelTwoAccountCategoryToLevelOneAccountCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :level_one_account_categories, :level_two_account_category, foreign_key: true, type: :uuid, index: { name: 'index_level_2_act_category_on_level_1_act_categories' }
  end
end
