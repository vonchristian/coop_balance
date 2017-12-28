class CreateStoreFrontConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :store_front_configs, id: :uuid do |t|
      t.belongs_to :cost_of_goods_sold_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :accounts_receivable_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :merchandise_inventory_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :sales_account, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end
  end
end
