class DropCategoriesColumns < ActiveRecord::Migration[7.0]
  def up
    remove_column :accounts, :level_one_account_category_id, if_exists: true
    remove_column :programs, :level_one_account_category_id, if_exists: true
    remove_column :office_programs, :level_one_account_category_id, if_exists: true
    remove_column :office_saving_products, :liability_account_category_id, if_exists: true
    remove_column :office_saving_products, :interest_expense_account_category_id, if_exists: true
    remove_column :office_loan_products, :receivable_account_category_id, if_exists: true
    remove_column :office_loan_products, :interest_revenue_account_category_id, if_exists: true
    remove_column :office_loan_products, :penalty_revenue_account_category_id, if_exists: true
    remove_column :office_share_capital_products, :equity_account_category_id, if_exists: true
    remove_column :office_time_deposit_products, :liability_account_category_id, if_exists: true
    remove_column :office_time_deposit_products, :interest_expense_account_category_id, if_exists: true
    remove_column :office_time_deposit_products, :break_contract_account_category_id, if_exists: true
    remove_column :office_loan_product_aging_groups, :level_one_account_category_id, if_exists: true
    remove_column :saving_product_interest_configs, :interest_expense_category_id, if_exists: true
    remove_column :loan_aging_groups, :level_two_account_category_id, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
