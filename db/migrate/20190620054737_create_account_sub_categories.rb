class CreateAccountSubCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :account_sub_categories, id: :uuid do |t|
      t.belongs_to :main_category, foreign_key: { to_table: :account_categories }, type: :uuid
      t.belongs_to :sub_category, foreign_key: { to_table: :account_categories }, type: :uuid

      t.timestamps
    end
  end
end
