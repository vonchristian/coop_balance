class ChangeNullInOfficeShareCapitalProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_null :office_share_capital_products, :equity_account_category_id, true
  end
end
