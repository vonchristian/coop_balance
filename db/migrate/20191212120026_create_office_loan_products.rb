class CreateOfficeLoanProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :office_loan_products, id: :uuid do |t|
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid
      t.belongs_to :loan_product, null: false, foreign_key: true, type: :uuid
      t.belongs_to :receivable_account_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid
      t.belongs_to :interest_revenue_account_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid, index: { name: 'index_interest_revenue_category_on_office_loan_products' }
      t.belongs_to :penalty_revenue_account_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid, index: { name: 'index_penalty_revenue_category_on_office_loan_products' }
      t.belongs_to :loan_protection_plan_provider, null: false, foreign_key: true, type: :uuid
      t.belongs_to :forwarding_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end
  end
end
