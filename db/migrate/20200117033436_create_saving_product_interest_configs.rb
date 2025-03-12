class CreateSavingProductInterestConfigs < ActiveRecord::Migration[6.0]
  def change
    create_table :saving_product_interest_configs, id: :uuid do |t|
      t.belongs_to :interest_expense_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid, index: { name: 'index_interest_category_on_saving_product_interest_configs' }
      t.belongs_to :saving_product, null: false, foreign_key: true, type: :uuid
      t.integer :interest_posting, default: 0
      t.decimal :annual_rate

      t.timestamps
    end
    add_index :saving_product_interest_configs, :interest_posting
  end
end
