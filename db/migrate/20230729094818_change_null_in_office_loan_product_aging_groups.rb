class ChangeNullInOfficeLoanProductAgingGroups < ActiveRecord::Migration[6.1]
  def change
    change_column_null :office_loan_product_aging_groups, :level_one_account_category_id, true
  end
end
