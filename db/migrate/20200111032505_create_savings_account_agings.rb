class CreateSavingsAccountAgings < ActiveRecord::Migration[6.0]
  def change
    create_table :savings_account_agings, id: :uuid do |t|
      t.belongs_to :savings_account, null: false, foreign_key: { to_table: :savings }, type: :uuid 
      t.belongs_to :savings_aging_group, null: false, foreign_key: true, type: :uuid 
      t.datetime :date

      t.timestamps
    end
  end
end
