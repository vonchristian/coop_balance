class ChangeNullInOfficeTimeDepositProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_null :office_time_deposit_products, :liability_account_category_id, true
    change_column_null :office_time_deposit_products, :interest_expense_account_category_id, true
    change_column_null :office_time_deposit_products, :break_contract_account_category_id, true
  end
end
