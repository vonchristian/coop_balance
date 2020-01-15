class CreateNetIncomeConfigs < ActiveRecord::Migration[6.0]
  def change
    create_table :net_income_configs, id: :uuid do |t|
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid 
      t.belongs_to :net_income_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid 
      t.integer :book_closing

      t.timestamps
    end
    add_index :net_income_configs, :book_closing
  end
end
