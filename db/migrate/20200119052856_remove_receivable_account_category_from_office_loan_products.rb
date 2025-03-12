class RemoveReceivableAccountCategoryFromOfficeLoanProducts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :office_loan_products, :receivable_account_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid
  end
end
