class AddCategorizeableToLevelOneAccountCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :level_one_account_categories, :categorizeable, polymorphic: true, type: :uuid, index: { name: "index_categorizeable_on_level_one_account_categories" }
  end
end
