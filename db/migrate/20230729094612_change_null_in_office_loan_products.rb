class ChangeNullInOfficeLoanProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_null :office_loan_products, :interest_revenue_account_category_id, true
    change_column_null :office_loan_products, :penalty_revenue_account_category_id, true
  end
end
