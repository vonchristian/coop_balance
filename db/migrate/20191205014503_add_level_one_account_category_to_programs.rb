class AddLevelOneAccountCategoryToPrograms < ActiveRecord::Migration[6.0]
  def change
    add_reference :programs, :level_one_account_category, foreign_key: true, type: :uuid 
  end
end
