class ChangeNullInOfficeSavingProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_null :office_saving_products, :liability_account_category_id, true
    change_column_null :office_saving_products, :interest_expense_account_category_id, true
    change_column_null :office_saving_products, :closing_account_category_id, true
  end
end
