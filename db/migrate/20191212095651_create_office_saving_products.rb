class CreateOfficeSavingProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :office_saving_products, id: :uuid do |t|
      t.belongs_to :liability_account_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid
      t.belongs_to :interest_expense_account_category, null: false, foreign_key:  { to_table: :level_one_account_categories }, type: :uuid, index: { name: 'index_int_expense_category_on_office_saving_products' }
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid
      t.belongs_to :closing_account_category, null: false, foreign_key:  { to_table: :level_one_account_categories }, type: :uuid
      t.belongs_to :forwarding_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :saving_product, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
