class AddAccountCategoryToLoanAgingGroups < ActiveRecord::Migration[6.0]
  def change
    add_reference :loan_aging_groups, :level_two_account_category, foreign_key: { to_table: :level_two_account_categories }, type: :uuid
  end
end
