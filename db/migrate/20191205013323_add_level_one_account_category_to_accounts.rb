class AddLevelOneAccountCategoryToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :accounts, :level_one_account_category, foreign_key: true, type: :uuid
  end
end
