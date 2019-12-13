class CreateOfficeTimeDepositProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :office_time_deposit_products, id: :uuid do |t|
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid
      t.belongs_to :liability_account_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid, index: { name: 'index_liability_category_on_office_time_deposit_products' }
      t.belongs_to :interest_expense_account_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid, index: { name: 'index_interest_expense_category_on_office_time_deposit_products' }
      t.belongs_to :break_contract_account_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid, index: { name: 'index_break_contract_category_on_office_time_deposit_products' }
      t.belongs_to :time_deposit_product, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
