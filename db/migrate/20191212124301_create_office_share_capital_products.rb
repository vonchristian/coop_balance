class CreateOfficeShareCapitalProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :office_share_capital_products, id: :uuid do |t|
      t.belongs_to :share_capital_product, null: false, foreign_key: true, type: :uuid
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid
      t.belongs_to :equity_account_category, null: false, foreign_key: { to_table: :level_one_account_categories }, type: :uuid, index: { name: 'index_equity_account_category_on_office_share_capital_products' }
      t.belongs_to :forwarding_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end
  end
end
